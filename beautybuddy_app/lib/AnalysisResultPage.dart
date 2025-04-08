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
        r += pixel.r.toInt();
        g += pixel.g.toInt();
        b += pixel.b.toInt();
        count++;
      }
    }

    final avgColor = Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);

    // === Step 1: Convert RGB -> HSL ===
    final hsl = HSLColor.fromColor(avgColor);
    double baseHue = hsl.hue;
    double lightness = hsl.lightness;
    double saturation = hsl.saturation;

    // === Step 2: Use emotion to shift hue ===
    List<double> hueShifts;

    if (widget.emotion.contains('Happy')) {
      hueShifts = [-30, 0, 30, 60, 90]; // analogous + complementary
    } else if (widget.emotion.contains('Tired')) {
      hueShifts = [-90, -60, -30, 0, 30]; // calming shades
    } else if (widget.emotion.contains('Serious')) {
      hueShifts = [-180, -150, 0, 150, 180]; // more formal contrasts
    } else {
      hueShifts = [-60, -30, 0, 30, 60]; // neutral blend
    }

    // === Step 3: Generate colors ===
    List<Color> shades = hueShifts.map((shift) {
      final newHue = (baseHue + shift) % 360;
      return HSLColor.fromAHSL(1.0, newHue, saturation, lightness).toColor();
    }).toList();

    // Add mid-tone variants (lighter/darker)
    List<Color> finalPalette = [
      ...shades.map((color) => HSLColor.fromColor(color).withLightness((lightness * 0.85).clamp(0.0, 1.0)).toColor()),
      ...shades.map((color) => HSLColor.fromColor(color).withLightness((lightness * 1.15).clamp(0.0, 1.0)).toColor()),
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
        ],
      ),
    );
  }
}