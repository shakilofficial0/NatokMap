import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/landmark.dart';

/// Database Helper for offline caching using SQLite
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('landmarks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE landmarks (
        id $idType,
        title $textType,
        latitude $realType,
        longitude $realType,
        image_url TEXT,
        local_image_path TEXT,
        created_at TEXT,
        updated_at TEXT,
        is_synced $intType
      )
    ''');
  }

  /// Insert a landmark
  Future<int> insertLandmark(Landmark landmark) async {
    final db = await database;
    return await db.insert(
      'landmarks',
      landmark.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all landmarks
  Future<List<Landmark>> getAllLandmarks() async {
    final db = await database;
    final result = await db.query(
      'landmarks',
      orderBy: 'created_at DESC',
    );
    return result.map((map) => Landmark.fromDbMap(map)).toList();
  }

  /// Get landmark by ID
  Future<Landmark?> getLandmarkById(int id) async {
    final db = await database;
    final maps = await db.query(
      'landmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Landmark.fromDbMap(maps.first);
    }
    return null;
  }

  /// Update a landmark
  Future<int> updateLandmark(Landmark landmark) async {
    final db = await database;
    return await db.update(
      'landmarks',
      landmark.toDbMap(),
      where: 'id = ?',
      whereArgs: [landmark.id],
    );
  }

  /// Delete a landmark
  Future<int> deleteLandmark(int id) async {
    final db = await database;
    return await db.delete(
      'landmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all landmarks
  Future<int> deleteAllLandmarks() async {
    final db = await database;
    return await db.delete('landmarks');
  }

  /// Get unsynced landmarks
  Future<List<Landmark>> getUnsyncedLandmarks() async {
    final db = await database;
    final result = await db.query(
      'landmarks',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return result.map((map) => Landmark.fromDbMap(map)).toList();
  }

  /// Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}
