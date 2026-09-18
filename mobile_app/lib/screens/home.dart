import 'package:flutter/material.dart';
import 'voice_assistant.dart';
import 'reminders.dart';
import '../games/memory_match.dart'; // We will build this in Phase 3

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ensuring high-contrast, elder-friendly UI with very large fonts
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('NeuroNER Assistant', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Voice Assistant Trigger
            ElevatedButton.icon(
              icon: Icon(Icons.mic, size: 48, color: Colors.white),
              label: Text('Talk to Assistant', style: TextStyle(fontSize: 32, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: EdgeInsets.symmetric(vertical: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceAssistantScreen()));
              },
            ),
            
            // Play Games Button
            ElevatedButton.icon(
              icon: Icon(Icons.videogame_asset, size: 48, color: Colors.black),
              label: Text('Play Memory Games', style: TextStyle(fontSize: 32, color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[600],
                padding: EdgeInsets.symmetric(vertical: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                // To be linked to Phase 3 games
                print("Launching culturally familiar memory games...");
              },
            ),

            // Daily Reminders Button
            ElevatedButton.icon(
              icon: Icon(Icons.alarm, size: 48, color: Colors.white),
              label: Text('Daily Reminders', style: TextStyle(fontSize: 32, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                padding: EdgeInsets.symmetric(vertical: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RemindersScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
