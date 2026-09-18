import '../services/local_db.dart';

class AdaptiveEngine {
  /// Calculates the next optimal difficulty level based on the user's historical performance.
  /// Goal: Maintain an ~80% success/engagement rate.
  static Future<int> calculateNextDifficulty(String gameType) async {
    final db = await LocalDatabase.instance.database;
    
    // Fetch last 5 sessions for this specific game
    final List<Map<String, dynamic>> recentSessions = await db.query(
      'game_sessions',
      where: 'game_type = ?',
      whereArgs: [gameType],
      orderBy: 'id DESC',
      limit: 5,
    );

    int currentDifficulty = 4; // Default starting difficulty (e.g., 4 pairs)

    if (recentSessions.isEmpty) {
      return currentDifficulty; // Baseline
    }

    currentDifficulty = recentSessions.first['difficulty_level'] as int;
    
    // Calculate average score and speed
    double totalScore = 0;
    int totalTime = 0;
    for (var session in recentSessions) {
      totalScore += (session['score'] as num).toDouble();
      totalTime += session['duration_seconds'] as int;
    }

    double avgScore = totalScore / recentSessions.length;
    double avgTime = totalTime / recentSessions.length;

    // Threshold-based Reinforcement Logic
    // If the patient is scoring very high quickly, gently increase difficulty
    if (avgScore > 90.0 && avgTime < 30.0) {
      print("AI ENGINE: Patient exceeding thresholds. Increasing difficulty to stimulate cognition.");
      return currentDifficulty + 1;
    } 
    // If patient is struggling (low score, high time), reduce difficulty to prevent frustration
    else if (avgScore < 50.0 || avgTime > 90.0) {
      print("AI ENGINE: Patient struggling. Decreasing difficulty to maintain engagement.");
      return currentDifficulty > 2 ? currentDifficulty - 1 : 2;
    }

    // Otherwise, keep it the same (Sweet spot found)
    print("AI ENGINE: Patient in optimal 80% engagement zone. Maintaining difficulty.");
    return currentDifficulty;
  }
}
