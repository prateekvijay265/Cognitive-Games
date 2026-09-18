import 'package:flutter/material.dart';
import '../ai/adaptive_engine.dart';
import '../services/local_db.dart';

class MemoryMatchGame extends StatefulWidget {
  @override
  _MemoryMatchGameState createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame> {
  int pairCount = 4; // Managed by AI Engine
  int attempts = 0;
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() async {
    // Determine optimal difficulty based on past performance
    int newDifficulty = await AdaptiveEngine.calculateNextDifficulty("MemoryMatch");
    setState(() {
      pairCount = newDifficulty;
      attempts = 0;
      startTime = DateTime.now();
    });
    print("Game initialized with \$pairCount pairs based on AI profile.");
  }

  void _onGameCompleted(bool success) async {
    final duration = DateTime.now().difference(startTime!).inSeconds;
    final score = success ? 100.0 - (attempts * 5) : 0.0;

    // Log to local SQLite DB
    await LocalDatabase.instance.insertGameSession({
      'game_type': 'MemoryMatch',
      'score': score,
      'duration_seconds': duration,
      'difficulty_level': pairCount,
    });

    print("Session Saved -> Score: \$score, Duration: \$duration s");
    
    // Provide encouraging voice feedback here (e.g., in regional language)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Match (Local Culture)', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.teal[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Find the matching pairs!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            // Mock UI for the grid of cards
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 16, 
                  mainAxisSpacing: 16
                ),
                itemCount: pairCount * 2,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.yellow[600],
                    child: Center(
                      child: Icon(Icons.help_outline, size: 64, color: Colors.black54),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _onGameCompleted(true),
              child: Text("Simulate Win", style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
