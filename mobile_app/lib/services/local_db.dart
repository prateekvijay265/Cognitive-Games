// lib/services/local_db.dart
// This file handles the local SQLite database for offline-first capabilities.
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('neuroner.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE game_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_type TEXT,
        score REAL,
        duration_seconds INTEGER,
        difficulty_level INTEGER,
        synced INTEGER DEFAULT 0
      )
    ''');
    
    await db.execute('''
      CREATE TABLE reminder_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reminder_type TEXT,
        status TEXT,
        timestamp TEXT,
        synced INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertGameSession(Map<String, dynamic> session) async {
    final db = await instance.database;
    return await db.insert('game_sessions', session);
  }
  
  Future<List<Map<String, Object?>>> getUnsyncedSessions() async {
    final db = await instance.database;
    return await db.query('game_sessions', where: 'synced = ?', whereArgs: [0]);
  }
}
