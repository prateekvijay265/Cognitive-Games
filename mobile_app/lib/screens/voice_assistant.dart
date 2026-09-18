import 'package:flutter/material.dart';
// Note: In a real flutter app, we would use packages like `flutter_tts` and `speech_to_text`.
// This is the boilerplate implementation.

class VoiceAssistantScreen extends StatefulWidget {
  @override
  _VoiceAssistantScreenState createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  bool _isListening = false;
  String _spokenText = "Tap the microphone to speak in your language.";

  // Mock function to simulate Assamese/Regional language TTS
  void speakGreeting() {
    print("TTS Engine (Bhashini/Google) triggering in Assamese: 'Nomoskar, aaji aponar bhal ne?'");
    setState(() {
      _spokenText = "Nomoskar, aaji aponar bhal ne? (Hello, how are you today?)";
    });
  }

  @override
  void initState() {
    super.initState();
    // Greet the user out loud automatically when they open this screen
    speakGreeting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Voice Assistant', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal[800],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Visual feedback for elders
              Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 120,
                color: _isListening ? Colors.red : Colors.teal[800],
              ),
              SizedBox(height: 40),
              Text(
                _spokenText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isListening = !_isListening;
                    if (_isListening) {
                      _spokenText = "Listening to Assamese/Meitei input...";
                    } else {
                      _spokenText = "Processing command...";
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isListening ? Colors.red : Colors.teal[800],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _isListening ? "STOP LISTENING" : "START LISTENING",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
