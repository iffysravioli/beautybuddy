import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class AnalysisResultPage extends StatefulWidget {
  final File imageFile;
  final String emotion;

  const AnalysisResultPage({
    super.key,
    required this.imageFile,
    required this.emotion,
  });

  @override
  State<AnalysisResultPage> createState() => _AnalysisResultPageState();
}

class _AnalysisResultPageState extends State<AnalysisResultPage> {
  List<Color> _palette = [];

  @override
  void initState() {
    super.initState();
    _generatePalette();
  }

  Future<void> _generatePalette() async {
    final bytes = await widget.imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) return;

    final centerX = image.width ~/ 2;
    final centerY = image.height ~/ 2;

    int r = 0, g = 0, b = 0, count = 0;

    for (int dx = -30; dx <= 30; dx++) {
      for (int dy = -30; dy <= 30; dy++) {
        final pixel = image.getPixelSafe(centerX + dx, centerY + dy);

// Use `.r`, `.g`, `.b` directly from Pixel object
        r += pixel.r.toInt();
        g += pixel.g.toInt();
        b += pixel.b.toInt();
        count++;
      }
    }

    final avgColor = Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);

    List<Color> shades = List.generate(10, (i) {
      final factor = (i - 5) * 10;
      return Color.fromARGB(
        255,
        (avgColor.red + factor).clamp(0, 255),
        (avgColor.green + factor ~/ 2).clamp(0, 255),
        (avgColor.blue + factor ~/ 2).clamp(0, 255),
      );
    });

    setState(() {
      _palette = shades;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F3),
      appBar: AppBar(
        title: const Text('Analysis Result'),
        backgroundColor: const Color(0xFF3B2213),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(widget.imageFile, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.emotion,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Palette',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Serif',
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 12),
          _palette.isEmpty
              ? const CircularProgressIndicator()
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _palette.map((color) {
              return Container(
                width: 24,
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black12),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}