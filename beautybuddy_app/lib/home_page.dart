import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:typed_data';
import 'recommendation_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController? _cameraController;
  late tfl.Interpreter _interpreter;
  String _emotion = "Detecting...";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadModel() async {
    _interpreter = await tfl.Interpreter.fromAsset('assets/emotion_model.tflite');
  }

  Future<void> _analyzeImage(CameraImage image) async {
    if (_interpreter == null) return;
    Uint8List inputBytes = _convertImageToByteList(image);
    var output = List.filled(1, 0).reshape([1, 1]);
    _interpreter.run(inputBytes, output);
    setState(() {
      _emotion = _mapEmotionLabel(output[0][0]);
    });
  }

  Uint8List _convertImageToByteList(CameraImage image) {
    return image.planes[0].bytes;
  }

  String _mapEmotionLabel(int index) {
    const emotions = ['Happy', 'Sad', 'Nervous', 'Angry', 'Neutral'];
    return emotions[index];
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          RecommendationPage(),
          Stack(
            children: [
              _cameraController == null || !_cameraController!.value.isInitialized
                  ? Center(child: CircularProgressIndicator())
                  : CameraPreview(_cameraController!),
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
                  onPressed: () async {
                    await _takePicture();
                  },
                  child: Icon(Icons.camera),
                ),
              )
            ],
          ),
          FavoritesPage(),
        ],
        onPageChanged: (index) {
          print("Page changed to index: $index");
        },
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      final image = await _cameraController!.takePicture();
      print("Picture taken: ${image.path}");
    } catch (e) {
      print("Error taking picture: $e");
    }
  }
}
