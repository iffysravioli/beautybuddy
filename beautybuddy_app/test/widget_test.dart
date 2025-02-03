Flutter Camera Emotion
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
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
    if (cameras.isEmpty) {
      print("No cameras available");
      return;
    }

    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
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

