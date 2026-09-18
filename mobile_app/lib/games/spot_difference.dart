import 'package:flutter/material.dart';
import '../ai/adaptive_engine.dart';
import '../services/local_db.dart';

class SpotDifferenceGame extends StatefulWidget {
  @override
  _SpotDifferenceGameState createState() => _SpotDifferenceGameState();
}

class _SpotDifferenceGameState extends State<SpotDifferenceGame> {
  int differenceCount = 3; 
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() async {
    int newDifficulty = await AdaptiveEngine.calculateNextDifficulty("SpotDifference");
    setState(() {
      // Difficulty dictates how many subtle differences to spawn
      differenceCount = newDifficulty; 
      startTime = DateTime.now();
    });
  }

  void _onGameCompleted(int errors) async {
    final duration = DateTime.now().difference(startTime!).inSeconds;
    final score = 100.0 - (errors * 10);

    await LocalDatabase.instance.insertGameSession({
      'game_type': 'SpotDifference',
      'score': score < 0 ? 0 : score,
      'duration_seconds': duration,
      'difficulty_level': differenceCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spot the Difference', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.teal[800],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Find \$differenceCount differences in the Northeast Village Scene", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            // Mock images side-by-side
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 150, color: Colors.blue[100], child: Center(child: Text("Image A"))),
                  Container(width: 150, color: Colors.blue[100], child: Center(child: Text("Image B"))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () => _onGameCompleted(0),
                child: Text("Simulate Win (0 Errors)", style: TextStyle(fontSize: 24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
