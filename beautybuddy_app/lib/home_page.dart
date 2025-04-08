import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
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
  String _emotionResult = '';
  String _statusMessage = 'Ready to capture';
  late Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCam = cameras
        .firstWhere((cam) => cam.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(frontCam, ResolutionPreset.high);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('emotion_model.tflite');
    print("✅ TensorFlow model loaded");
    print("Number of TFLite inputs: ${_interpreter}");
  }

  Future<void> _captureAndAnalyze() async {
    try {
      if (!_cameraController.value.isInitialized) return;

      setState(() {
        _statusMessage = '📷 Capturing...';
        _emotionResult = '';
      });

      final XFile xfile = await _cameraController.takePicture();
      final File imageFile = File(xfile.path);

      final exists = await imageFile.exists();
      if (!exists) {
        setState(() {
          _statusMessage = '❌ Failed to save image.';
        });
        return;
      }

      setState(() {
        _capturedImage = imageFile;
        _statusMessage = '🔍 Detecting face...';
      });

      final hasFace = await _detectFace(imageFile);
      if (!hasFace) {
        setState(() {
          _statusMessage = '❌ No face detected.';
        });
        return;
      }

      setState(() {
        _statusMessage = '🤖 Analyzing with TensorFlow...';
      });

      final emotion = await _analyzeEmotion(imageFile);

      setState(() {
        _emotionResult = 'Detected Emotion: $emotion';
        _statusMessage = '✅ Face and emotion analyzed.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '⚠️ Error: ${e.toString()}';
      });
      print('Error during capture and analysis: $e');
    }
  }
  Future<bool> _detectFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);

    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    try {
      final faces = await faceDetector.processImage(inputImage);
      print('🧠 MLKit: Detected ${faces.length} face(s)');
      return faces.isNotEmpty;
    } catch (e) {
      print('❌ Face detection error: $e');
      return false;
    }
  }

  Future<String> _analyzeEmotion(File imageFile) async {
    // TODO: Add actual TFLite model input/output logic here
    List<String> emotions = [
      'Happy',
      'Sad',
      'Angry',
      'Surprised',
      'Neutral',
      'Disgusted',
      'Fearful'
    ];
    List<double> mockOutput = List.generate(7, (_) => Random().nextDouble());
    int maxIndex = mockOutput.indexOf(mockOutput.reduce(max));
    return emotions[maxIndex];
  }

  void _reset() {
    setState(() {
      _capturedImage = null;
      _emotionResult = '';
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
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _capturedImage != null
                        ? Image.file(_capturedImage!,
                            fit: BoxFit.cover, width: double.infinity)
                        : (_isCameraInitialized
                            ? CameraPreview(_cameraController)
                            : const Center(child: CircularProgressIndicator())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _emotionResult,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B2213),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: _capturedImage == null ? _captureAndAnalyze : null,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Analyze"),
                ),
                if (_capturedImage != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: _reset,
                    icon: const Icon(Icons.close),
                    label: const Text("Reset"),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
