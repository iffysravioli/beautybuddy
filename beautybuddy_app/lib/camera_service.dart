import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  File? _capturedImage;
  String _emotionResult = "";
  late Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere((cam) => cam.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(frontCam, ResolutionPreset.medium);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('emotion_model.tflite');
  }

  Future<void> _captureAndAnalyze() async {
    if (!_cameraController.value.isInitialized) return;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _cameraController.takePicture().then((XFile file) async {
      final imageFile = File(file.path);
      setState(() {
        _capturedImage = imageFile;
      });

      final faceDetected = await _detectFace(imageFile);
      if (!faceDetected) {
        setState(() {
          _emotionResult = "No face detected.";
        });
        return;
      }

      final result = await _analyzeEmotion(imageFile);
      setState(() {
        _emotionResult = result;
      });
    });
  }

  Future<bool> _detectFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
      ),
    );
    final faces = await faceDetector.processImage(inputImage);
    return faces.isNotEmpty;
  }

  Future<String> _analyzeEmotion(File imageFile) async {
    // Simulate prediction (you will replace this with your actual model logic)
    // Let's assume the model returns a list of 7 emotion probabilities
    List<String> emotions = ['Happy', 'Sad', 'Angry', 'Surprised', 'Neutral', 'Disgusted', 'Fearful'];
    List<double> mockOutput = List.generate(7, (_) => Random().nextDouble());

    int maxIndex = mockOutput.indexOf(mockOutput.reduce(max));
    return emotions[maxIndex];
  }

  void _reset() {
    setState(() {
      _capturedImage = null;
      _emotionResult = "";
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F3),
      body: SafeArea(
        child: Column(
          children: [
            if (_capturedImage == null && _isCameraInitialized)
              AspectRatio(
                aspectRatio: _cameraController.value.aspectRatio,
                child: CameraPreview(_cameraController),
              )
            else if (_capturedImage != null)
              Image.file(_capturedImage!, height: 400, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              _emotionResult.isEmpty ? 'Tap the button to analyze your emotion' : 'Emotion: $_emotionResult',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B2213),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _capturedImage == null ? _captureAndAnalyze : null,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Analyze"),
                ),
                if (_capturedImage != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _reset,
                    icon: const Icon(Icons.close),
                    label: const Text("Clear"),
                  ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}