// lib/services/sync_manager.dart
// This background service monitors connectivity and safely uploads cached data.
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'local_db.dart';

class SyncManager {
  static const String _baseUrl = "https://your-api-url.com/sync"; // Replace with actual backend IP/URL

  static Future<void> syncDataWhenOnline() async {
    // 1. Check internet connectivity (e.g., using connectivity_plus package)
    bool isOnline = true; // Placeholder for connectivity check

    if (isOnline) {
      final db = LocalDatabase.instance;
      
      // Sync Game Sessions
      final unsyncedGames = await db.getUnsyncedSessions();
      for (var game in unsyncedGames) {
        try {
          final response = await http.post(
            Uri.parse('$_baseUrl/games/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'patient_id': 1, // Mock patient ID
              'game_type': game['game_type'],
              'score': game['score'],
              'duration_seconds': game['duration_seconds'],
              'difficulty_level': game['difficulty_level']
            }),
          );

          if (response.statusCode == 200) {
            // Mark as synced locally
            final sqliteDb = await db.database;
            await sqliteDb.update('game_sessions', {'synced': 1}, where: 'id = ?', whereArgs: [game['id']]);
          }
        } catch (e) {
          print("Failed to sync game session: \$e");
        }
      }
    }
  }
}
