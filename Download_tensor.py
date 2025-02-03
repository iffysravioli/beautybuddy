import tensorflow as tf

# Load the Keras model
model = tf.keras.models.load_model("emotion_model8.h5")  # Change "model.h5" to your file path

# Convert the model to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save the converted TFLite model
with open("emotion_model.tflite", "wb") as f:
    f.write(tflite_model)

print("Model converted and saved as emotion_model.tflite")