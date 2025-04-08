import 'dart:math';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> palettes = [
    {
      'date': 'April 18, 2025',
      'colors': [
        0xFF99C3D1, 0xFFC1A389, 0xFFEFD3BD, 0xFFDC9745, 0xFFE47D5F,
        0xFF2F475B, 0xFF5B3C2E, 0xFFC0745F, 0xFF9A624A, 0xFF3C1F16,
      ],
      'similarity': 85,
    },
    {
      'date': 'March 12, 2025',
      'colors': [
        0xFF99C3D1, 0xFFC1A389, 0xFFEFD3BD, 0xFFDC9745, 0xFFE47D5F,
        0xFF397DED, 0xFFD84926, 0xFFDFBEB8, 0xFF524D4A, 0xFFD84926,
      ],
      'similarity': 62,
    },
    {
      'date': 'January 24, 2025',
      'colors': [
        0xFF99C3D1, 0xFFC1A389, 0xFFEFD3BD, 0xFFDC9745, 0xFFE47D5F,
        0xFF2F475B, 0xFF5B3C2E, 0xFFC0745F, 0xFF9A624A, 0xFF3C1F16,
      ],
      'similarity': 90,
    },
  ];

  void _deletePalette(int index) {
    setState(() {
      palettes.removeAt(index);
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Palette?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              _deletePalette(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showColorInfo(int colorHex, String date) {
    final String hex = '#${colorHex.toRadixString(16).substring(2).toUpperCase()}';
    final int usageCount = Random().nextInt(10) + 1;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Color Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(backgroundColor: Color(colorHex), radius: 30),
            const SizedBox(height: 12),
            Text('Hex Code: $hex'),
            Text('Date Used: $date'),
            Text('Seen $usageCount similar times'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaletteItem(Map<String, dynamic> palette, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          palette['date'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: (palette['colors'] as List<int>).map((color) {
                  return GestureDetector(
                    onTap: () => _showColorInfo(color, palette['date']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${palette['similarity']}% similar",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B2213), Color(0xFFD2BBA0)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _confirmDelete(index),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: palettes.length,
        itemBuilder: (context, index) =>
            _buildPaletteItem(palettes[index], index),
      ),
    );
  }
}