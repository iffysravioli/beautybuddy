// Save as upload_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> uploadVideo(File file) async {
  final uri = Uri.parse("http://10.26.140.25:5000/upload");
  final request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('video', file.path));

  final response = await request.send();
  if (response.statusCode == 200) {
    final data = await response.stream.bytesToString();
    return jsonDecode(data);
  } else {
    return null;
  }
}