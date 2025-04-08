import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraService {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isEmpty) {
      print("No cameras available");
      return;
    }
    await startCamera();
  }

  Future<void> startCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }
    _cameraController = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController!.initialize();
  }

  void switchCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    startCamera();
  }

  Future<XFile?> takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return null;
    }
    return await _cameraController!.takePicture();
  }

  CameraController? get cameraController => _cameraController;
}
