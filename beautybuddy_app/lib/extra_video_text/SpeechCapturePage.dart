import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechCapturePage extends StatefulWidget {
  const SpeechCapturePage({super.key});

  @override
  State<SpeechCapturePage> createState() => _SpeechCapturePageState();
}

class _SpeechCapturePageState extends State<SpeechCapturePage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "Press the mic and tell us your plan for today";

  @override
  void initState() {
    super.initState();
    _speech.initialize();
  }

  void _startListening() async {
    if (!_isListening) {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 15),
      );
      setState(() => _isListening = true);
    } else {
      _speech.stop();
      setState(() => _isListening = false);
      // TODO: Send `_text` to BERT classifier
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tell us your plan")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _text,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _startListening,
              icon: Icon(_isListening ? Icons.stop : Icons.mic),
              label: Text(_isListening ? "Stop" : "Start Talking"),
            ),
          ],
        ),
      ),
    );
  }
}