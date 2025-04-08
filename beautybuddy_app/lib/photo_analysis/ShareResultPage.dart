import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareResultPage extends StatefulWidget {
  final File croppedFace;
  final String undertone;
  final List<Color> palette;

  const ShareResultPage({
    super.key,
    required this.croppedFace,
    required this.undertone,
    required this.palette,
  });

  @override
  State<ShareResultPage> createState() => _ShareResultPageState();
}

class _ShareResultPageState extends State<ShareResultPage> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _saveAndShareImage() async {
    final image = await _screenshotController.capture();

    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/beauty_buddy_share.png');
    await file.writeAsBytes(image);

    await Share.shareXFiles([XFile(file.path)], text: 'I just got analyzed by Beauty Buddy! 💅🏾✨');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F3),
      appBar: AppBar(
        title: const Text('Share Your Results'),
        backgroundColor: const Color(0xFF3B2213),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'My Undertone is:',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Serif',
                        color: Colors.brown[800],
                      ),
                    ),
                    Text(
                      widget.undertone,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown[100],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: Image.file(widget.croppedFace, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Recommended Palette:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 12),
                    for (int i = 0; i < 2; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.palette
                            .skip(i * 5)
                            .take(5)
                            .map((color) => Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12),
                          ),
                        ))
                            .toList(),
                      ),
                    const SizedBox(height: 30),
                    const Text(
                      '✨ Analyzed by Beauty Buddy ✨',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveAndShareImage,
              icon: const Icon(Icons.share),
              label: const Text('Share or Save PNG'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B2213),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}