import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_service.dart';
import 'image_processing.dart';
import 'recommendation_page.dart';
import 'favorites_page.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CameraService _cameraService = CameraService();
  final ImageProcessing _imageProcessing = ImageProcessing();
  String _emotion = "Detecting...";
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _cameraService.initializeCamera();
    await _imageProcessing.loadModel();
    setState(() {});
  }

  Future<void> _takePicture() async {
    final XFile? imageFile = await _cameraService.takePicture();
    if (imageFile != null) {
      setState(() {
        _capturedImage = File(imageFile.path);
      });

      // Show image for 2 seconds before processing
      await Future.delayed(Duration(seconds: 2));

      final emotion = await _imageProcessing.detectFaceAndEmotion(imageFile);
      setState(() {
        _emotion = "Your expression: $emotion";
        _capturedImage = null; // Hide image after processing
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          RecommendationPage(),
          Stack(
            children: [
              if (_cameraService.cameraController == null || !_cameraService.cameraController!.value.isInitialized)
                Center(child: CircularProgressIndicator())
              else
                CameraPreview(_cameraService.cameraController!),

              // Show captured image temporarily
              if (_capturedImage != null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.6), // Semi-transparent overlay
                    child: Center(
                      child: Image.file(_capturedImage!, fit: BoxFit.contain),
                    ),
                  ),
                ),

              Positioned(
                top: 50,
                left: 20,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _emotion,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: MediaQuery.of(context).size.width / 2 - 30,
                child: FloatingActionButton(
                  onPressed: _takePicture,
                  child: Icon(Icons.camera_alt),
                ),
              ),
              Positioned(
                bottom: 50,
                right: 20,
                child: FloatingActionButton(
                  onPressed: _cameraService.switchCamera,
                  child: Icon(Icons.flip_camera_ios),
                ),
              ),
            ],
          ),
          FavoritesPage(),
        ],
      ),
    );
  }
}