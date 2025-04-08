// Save as results_page.dart
import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ResultsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F3),
      appBar: AppBar(
        title: const Text('Style Insight'),
        backgroundColor: const Color(0xFF3B2213),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📝 Transcript:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(data['transcript'] ?? 'N/A'),
            const SizedBox(height: 16),
            Text('😊 Mood: ${data['mood'] ?? 'Unknown'}'),
            Text('🎯 Activity: ${data['activity'] ?? 'Unknown'}'),
            Text('📍 Context: ${data['context'] ?? 'Unknown'}'),
          ],
        ),
      ),
    );
  }
}