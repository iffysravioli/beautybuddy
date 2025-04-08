import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'UndertoneInfoPage.dart'; // <-- You'll create this next

class AnalysisResultPage extends StatefulWidget {
  final File imageFile;
  final String emotion;


  final Rect faceRect;

  const AnalysisResultPage({
    super.key,
    required this.imageFile,
    required this.emotion,
    required this.faceRect,
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
        r += pixel.r.toInt();
        g += pixel.g.toInt();
        b += pixel.b.toInt();
        count++;
      }
    }

    final avgColor = Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);
    final hsl = HSLColor.fromColor(avgColor);
    double baseHue = hsl.hue;
    double lightness = hsl.lightness;
    double saturation = hsl.saturation;

    List<double> hueShifts;

    if (widget.emotion.contains('Happy')) {
      hueShifts = [-30, 0, 30, 60, 90];
    } else if (widget.emotion.contains('Tired')) {
      hueShifts = [-90, -60, -30, 0, 30];
    } else if (widget.emotion.contains('Serious')) {
      hueShifts = [-180, -150, 0, 150, 180];
    } else {
      hueShifts = [-60, -30, 0, 30, 60];
    }

    List<Color> shades = hueShifts.map((shift) {
      final newHue = (baseHue + shift) % 360;
      return HSLColor.fromAHSL(1.0, newHue, saturation, lightness).toColor();
    }).toList();

    List<Color> finalPalette = [
      ...shades.map((c) => HSLColor.fromColor(c).withLightness((lightness * 0.85).clamp(0.0, 1.0)).toColor()),
      ...shades.map((c) => HSLColor.fromColor(c).withLightness((lightness * 1.15).clamp(0.0, 1.0)).toColor()),
    ];

    setState(() {
      _palette = finalPalette;
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
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UndertoneInfoPage(
                      imageFile: widget.imageFile,
                      palette: _palette,
                      faceRect: widget.faceRect, // ✅ <--- include this
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B2213),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('View your color palette and undertone analysis'),
            ),
          ),

        ],
      ),
    );
  }
}