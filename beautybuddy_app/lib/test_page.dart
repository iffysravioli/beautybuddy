import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'AnalysisResultPage.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  String _statusMessage = 'Initializing camera...';
  String _emotionResult = 'Waiting for input...';
  late FaceDetector _faceDetector;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCam,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController.initialize();
    _cameraController.startImageStream(_processCameraImage);

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
        _statusMessage = 'Camera ready';
      });
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    final InputImage? inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isProcessing = false;
      return;
    }

    final List<Face> faces = await _faceDetector.processImage(inputImage);
    if (faces.isEmpty) {
      setState(() {
        _emotionResult = '❌ No face detected';
      });
      _isProcessing = false;
      return;
    }

    final face = faces.first;
    final smile = face.smilingProbability ?? 0.0;
    final leftEye = face.leftEyeOpenProbability ?? 0.0;
    final rightEye = face.rightEyeOpenProbability ?? 0.0;

    String emotion = 'Neutral';
    if (smile > 0.7) {
      emotion = 'Happy 😊';
    } else if (leftEye < 0.3 && rightEye < 0.3) {
      emotion = 'Tired 😴';
    } else if (smile < 0.2) {
      emotion = 'Serious 😐';
    }

    setState(() {
      _emotionResult = 'Detected: $emotion';
      _statusMessage = '✅ Face detected';
    });

    await Future.delayed(const Duration(seconds: 1)); // Limit analysis rate
    _isProcessing = false;
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameraController.description;
    final sensorOrientation = camera.sensorOrientation;

    final InputImageRotation rotation = InputImageRotationValue.fromRawValue(sensorOrientation) ??
        InputImageRotation.rotation0deg;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F3),
      appBar: AppBar(
        title: const Text('Live Emotion Test (ML Kit)'),
        backgroundColor: const Color(0xFF3B2213),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(_statusMessage, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            // ⬇️ Bigger Camera Preview
            Expanded(
              flex: 6,
              child: _isCameraInitialized
                  ? AspectRatio(
                aspectRatio: _cameraController.value.aspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CameraPreview(_cameraController),
                ),
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),

            // Emotion Result
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _emotionResult,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
                textAlign: TextAlign.center,
              ),
            ),
// Inside your build method, right before the last SizedBox:

            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton.icon(
                onPressed: _emotionResult.contains('Detected:')
                    ? () async {
                  try {
                    final file = await _cameraController.takePicture();
                    final imageFile = File(file.path);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnalysisResultPage(
                          imageFile: imageFile,
                          emotion: _emotionResult,
                        ),
                      ),
                    );
                  } catch (e) {
                    setState(() {
                      _statusMessage = '❌ Failed to capture for analysis.';
                    });
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B2213),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.analytics_outlined),
                label: const Text("Analyze Face"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }}