from flask import Flask, request, jsonify
import whisper
from transformers import pipeline
import os
from pydub import AudioSegment
import uuid

app = Flask(__name__)

# Load models once at startup
asr_model = whisper.load_model("base")
bert_pipeline = pipeline("zero-shot-classification", model="facebook/bart-large-mnli")

# Labels for classification
LABELS_MOOD = ["happy", "sad", "tired", "excited", "nervous", "angry", "calm"]
LABELS_ACTIVITY = ["studying", "going to a party", "going to work", "going to school", "going to the beach", "going out", "resting"]
LABELS_CONTEXT = ["beach", "home", "school", "office", "mall", "park"]

@app.route("/upload", methods=["POST"])
def upload():
    try:
        if "video" not in request.files:
            return jsonify({"error": "No video file provided"}), 400

        file = request.files["video"]
        filename = str(uuid.uuid4())
        video_path = f"temp/{filename}.mp4"
        audio_path = f"temp/{filename}.wav"

        # Save video
        file.save(video_path)

        # Extract audio
        audio = AudioSegment.from_file(video_path)
        audio.export(audio_path, format="wav")

        # Speech-to-text with Whisper
        result = asr_model.transcribe(audio_path)
        transcript = result.get("text", "").strip()

        if not transcript:
            raise Exception("No speech detected")

        # Run zero-shot classification
        mood_result = bert_pipeline(transcript, LABELS_MOOD)
        activity_result = bert_pipeline(transcript, LABELS_ACTIVITY)
        context_result = bert_pipeline(transcript, LABELS_CONTEXT)

        mood = mood_result["labels"][0]
        activity = activity_result["labels"][0]
        context = context_result["labels"][0]

        # Clean up files
        os.remove(video_path)
        os.remove(audio_path)

        return jsonify({
            "transcript": transcript,
            "mood": mood,
            "activity": activity,
            "context": context
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    os.makedirs("temp", exist_ok=True)
    app.run(host="0.0.0.0", port=5000)