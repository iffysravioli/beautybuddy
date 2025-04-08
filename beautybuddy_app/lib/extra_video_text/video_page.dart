// // Save as video_page.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
// import 'upload_service.dart';
// import 'results_page.dart';
// import 'analyzing_page.dart';
//
// class VideoPage extends StatefulWidget {
//   const VideoPage({super.key});
//
//   @override
//   State<VideoPage> createState() => _VideoPageState();
// }
//
// class _VideoPageState extends State<VideoPage> {
//   late CameraController _controller;
//   bool _isInitialized = false;
//   bool _isRecording = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }
//
//   Future<void> _initCamera() async {
//     final cameras = await availableCameras();
//     final front = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
//     _controller = CameraController(front, ResolutionPreset.medium);
//     await _controller.initialize();
//     setState(() => _isInitialized = true);
//   }
//
//   Future<void> _recordAndUpload() async {
//     final tempDir = await getTemporaryDirectory();
//     final filePath = '${tempDir.path}/input_video.mp4';
//     await _controller.startVideoRecording();
//     setState(() => _isRecording = true);
//     await Future.delayed(const Duration(seconds: 10));
//     final file = await _controller.stopVideoRecording();
//     setState(() => _isRecording = false);
//
//     if (context.mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => AnalyzingPage(videoFile: File(file.path))),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F6F3),
//       appBar: AppBar(
//         title: const Text('Record Your Voice'),
//         backgroundColor: const Color(0xFF3B2213),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _isInitialized
//                 ? CameraPreview(_controller)
//                 : const Center(child: CircularProgressIndicator()),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: _isRecording ? null : _recordAndUpload,
//             icon: const Icon(Icons.videocam),
//             label: Text(_isRecording ? 'Recording...' : 'Record 5s Video'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF3B2213),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }