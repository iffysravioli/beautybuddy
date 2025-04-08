// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class AnalyzingPage extends StatefulWidget {
//   final File videoFile;
//
//   const AnalyzingPage({super.key, required this.videoFile});
//
//   @override
//   State<AnalyzingPage> createState() => _AnalyzingPageState();
// }
//
// class _AnalyzingPageState extends State<AnalyzingPage> {
//   String transcript = '';
//   String mood = '';
//   String activity = '';
//   String contextPlace = '';
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _processVideo();
//   }
//
//   Future<void> _processVideo() async {
//     try {
//       final tempDir = await getTemporaryDirectory();
//       final audioPath = '${tempDir.path}/temp_audio.wav';
//
//       // ✅ Extract audio from in-memory video
//       await FFmpegKit.execute(
//           '-i "${widget.videoFile.path}" -vn -acodec pcm_s16le -ar 44100 -ac 2 "$audioPath"');
//
//       // ✅ Upload to backend
//       final uri =
//           Uri.parse('http://<your-ip>:5000/upload'); // change to your IP
//       final request = http.MultipartRequest('POST', uri)
//         ..files.add(await http.MultipartFile.fromPath('video', audioPath));
//
//       final response = await request.send();
//       final body = await response.stream.bytesToString();
//
//       if (response.statusCode == 200) {
//         final data = json.decode(body);
//         setState(() {
//           transcript = data['transcript'];
//           mood = data['mood'];
//           activity = data['activity'];
//           contextPlace = data['context'];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           transcript = '⚠️ Error: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//
//       // ✅ Clean up
//       File(audioPath).delete();
//     } catch (e) {
//       setState(() {
//         transcript = '⚠️ Processing failed: $e';
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F6F3),
//       appBar: AppBar(
//         title: const Text('Analyzing...'),
//         backgroundColor: const Color(0xFF3B2213),
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator()
//             : Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("🗣 Transcript:\n$transcript\n",
//                         style: const TextStyle(fontSize: 16)),
//                     Text("😌 Mood: $mood"),
//                     Text("🏃 Activity: $activity"),
//                     Text("📍 Context: $contextPlace"),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
