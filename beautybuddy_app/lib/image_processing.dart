import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';

class ImageProcessing {
  late tfl.Interpreter _interpreter;
  final FaceDetector _faceDetector = FaceDetector(options: FaceDetectorOptions(enableClassification: true));

  Future<void> loadModel() async {
    _interpreter = await tfl.Interpreter.fromAsset('assets/emotion_model.tflite');
    print("🔥 TFLite Model Loaded Successfully!");
  }

  Future<String> detectFaceAndEmotion(XFile imageFile) async {
    print("📸 Processing image: ${imageFile.path}");
    final inputImage = InputImage.fromFile(File(imageFile.path));
    List<Face> faces = await _faceDetector.processImage(inputImage);
    print("🧐 Faces detected: ${faces.length}");

    if (faces.isEmpty) {
      return "No face detected";
    }
    return await runTFLiteModel(imageFile);
  }

  Future<String> runTFLiteModel(XFile imageFile) async {
    Uint8List imageBytes = await File(imageFile.path).readAsBytes();
    var input = preprocessImage(imageBytes);
    print("📥 Image preprocessed for model");
    var inputTensor = input.reshape([1, 48, 48, 1]);
    var output = List.filled(1 * 7, 0.0).reshape([1, 7]);

    _interpreter.run(inputTensor, output);
    print("✅ Model inference complete");

    int predictedIndex = output[0].indexWhere((value) =>
    value == output[0].reduce((double a, double b) => a > b ? a : b));

    const emotions = ['Happy', 'Sad', 'Angry', 'Neutral', 'Surprised', 'Fear', 'Disgust'];
    return predictedIndex >= 0 && predictedIndex < emotions.length
        ? emotions[predictedIndex]
        : "Unknown";
  }

  Uint8List preprocessImage(Uint8List imageBytes) {
    int inputSize = 48;
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      print("🚨 Error decoding image!");
      return Uint8List(0);
    }
    img.Image resizedImage = img.copyResize(image, width: inputSize, height: inputSize);
    return Uint8List.fromList(resizedImage.getBytes());
  }
}