import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class UndertoneInfoPage extends StatefulWidget {
  final File imageFile;
  final List<Color> palette;
  final Rect faceRect;

  const UndertoneInfoPage({
    super.key,
    required this.imageFile,
    required this.palette,
    required this.faceRect,
  });

  @override
  State<UndertoneInfoPage> createState() => _UndertoneInfoPageState();
}

class _UndertoneInfoPageState extends State<UndertoneInfoPage> {
  String undertone = 'Analyzing...';
  File? croppedFace;

  @override
  void initState() {
    super.initState();
    _cropFaceAndAnalyzeUndertone();
  }

  Future<void> _cropFaceAndAnalyzeUndertone() async {
    final bytes = await widget.imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return;

    final rect = widget.faceRect;

    int left = max(0, rect.left.toInt() - 20);
    int top = max(0, rect.top.toInt() - 40);
    int width = min(image.width - left, rect.width.toInt() + 40);
    int height = min(image.height - top, rect.height.toInt() + 60);

    final croppedImg = img.copyCrop(
      image,
      x: left,
      y: top,
      width: width,
      height: height,
    );

    final whiteBg = img.Image(width: width, height: height);
    img.fill(whiteBg, color: img.ColorRgb8(255, 255, 255));
    img.compositeImage(whiteBg, croppedImg, dstX: 0, dstY: 0);

    final tempDir = Directory.systemTemp;
    final croppedPath = '${tempDir.path}/cropped_face_${DateTime.now().millisecondsSinceEpoch}.png';
    final resultFile = File(croppedPath)..writeAsBytesSync(img.encodePng(whiteBg));

    // Sample the center pixel
    final sampleX = croppedImg.width ~/ 2;
    final sampleY = croppedImg.height ~/ 2;
    final pixel = croppedImg.getPixelSafe(sampleX, sampleY);
    final r = pixel.r;
    final g = pixel.g;
    final b = pixel.b;

    String tone = 'Neutral';
    if (r > b && r > g) {
      tone = 'Warm';
    } else if (b > r) {
      tone = 'Cool';
    }

    setState(() {
      undertone = tone;
      croppedFace = resultFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F3),
      appBar: AppBar(
        title: const Text('Undertone Analysis'),
        backgroundColor: const Color(0xFF3B2213),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Your Color Circle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Serif',
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: widget.palette.map((color) {
                return Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(color: Colors.black12),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Your undertone: $undertone',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recommended Palette',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < 2; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.palette
                    .skip(i * 5)
                    .take(5)
                    .map((color) => Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ))
                    .toList(),
              ),
            const SizedBox(height: 20),
            const Text(
              'How You Look with White Background',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 8),
            croppedFace != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                croppedFace!,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}