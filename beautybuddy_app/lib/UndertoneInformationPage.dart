// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';
//
// class UndertoneInfoPage extends StatefulWidget {
//   final File imageFile;
//
//   const UndertoneInfoPage({
//     super.key,
//     required this.imageFile,
//   });
//
//   @override
//   State<UndertoneInfoPage> createState() => _UndertoneInfoPageState();
// }
//
// class _UndertoneInfoPageState extends State<UndertoneInfoPage> {
//   File? _croppedFace;
//
//   @override
//   void initState() {
//     super.initState();
//     _detectAndCropFace();
//   }
//
//   Future<void> _detectAndCropFace() async {
//     final inputImage = InputImage.fromFile(widget.imageFile);
//     final faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         performanceMode: FaceDetectorMode.accurate,
//         enableClassification: false,
//         enableLandmarks: false,
//         enableTracking: false,
//       ),
//     );
//
//     final faces = await faceDetector.processImage(inputImage);
//     if (faces.isEmpty) return;
//
//     final face = faces.first.boundingBox;
//     final imageBytes = await widget.imageFile.readAsBytes();
//     final decodedImg = img.decodeImage(imageBytes);
//
//     if (decodedImg == null) return;
//
//     final cropX = face.left.toInt().clamp(0, decodedImg.width);
//     final cropY = face.top.toInt().clamp(0, decodedImg.height);
//     final cropWidth = face.width.toInt().clamp(0, decodedImg.width - cropX);
//     final cropHeight = face.height.toInt().clamp(0, decodedImg.height - cropY);
//
//     final faceCrop = img.copyCrop(decodedImg, cropX, cropY, cropWidth, cropHeight);
//
//     final whiteBg = img.Image(faceCrop.width + 60, faceCrop.height + 60);
//     img.fill(whiteBg, img.getColor(255, 255, 255));
//     img.copyInto(whiteBg, faceCrop, dstX: 30, dstY: 30);
//
//     final outputBytes = img.encodeJpg(whiteBg);
//     final tempDir = await getTemporaryDirectory();
//     final croppedFile = File('${tempDir.path}/cropped_face.jpg');
//     await croppedFile.writeAsBytes(outputBytes);
//
//     setState(() {
//       _croppedFace = croppedFile;
//     });
//
//     await faceDetector.close();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F6F3),
//       appBar: AppBar(
//         title: const Text('Your Undertone'),
//         backgroundColor: const Color(0xFF3B2213),
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _croppedFace == null
//             ? const Center(child: CircularProgressIndicator())
//             : Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.file(
//                 _croppedFace!,
//                 height: 250,
//                 width: 250,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Based on your color analysis, you have a warm undertone.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 12),
//             Container(
//               height: 24,
//               width: 200,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Colors.blue, Colors.orange],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.only(left: 140),
//               child: Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'This means your skin glows in warm earthy tones like golden yellow, orange, or rich browns!',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }