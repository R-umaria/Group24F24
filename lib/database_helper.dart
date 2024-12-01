import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Table name and columns for trip events
  static const String _tableName = 'trip_events';
  static const String _columnId = 'id';
  static const String _columnEventType = 'event_type';
  static const String _columnTimestamp = 'timestamp';
  static const String _columnLatitude = 'latitude';
  static const String _columnLongitude = 'longitude';
  static const String _columnSpeed = 'speed';

  // Table name and columns for settings
  static const String _settingsTable = 'settings';
  static const String _columnSettingKey = 'key';
  static const String _columnSettingValue = 'value';

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Create the database and the tables
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'trips.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // Create the tables
  Future<void> _createDatabase(Database db, int version) async {
    // Create trip_events table
    await db.execute(''' 
      CREATE TABLE $_tableName (
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnEventType TEXT,
        $_columnTimestamp TEXT,
        $_columnLatitude REAL,
        $_columnLongitude REAL,
        $_columnSpeed REAL
      )
    ''');
    // Create settings table
    await db.execute('''
      CREATE TABLE $_settingsTable (
        $_columnSettingKey TEXT PRIMARY KEY,
        $_columnSettingValue TEXT
      )
    ''');
  }

  // Insert trip data into the database
  Future<void> insertEvent(Map<String, dynamic> eventData) async {
    final db = await database;
    await db.insert(
      _tableName,
      eventData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all trip events from the database
  Future<List<Map<String, dynamic>>> getAllTrips() async {
    final db = await database;
    return await db.query(_tableName);
  }

  // Retrieve events by type (optional filtering method)
  Future<List<Map<String, dynamic>>> getEventsByType(String eventType) async {
    final db = await database;
    return await db.query(
      _tableName,
      where: '$_columnEventType = ?',
      whereArgs: [eventType],
    );
  }

  // Clear all events from the table (useful for testing)
  Future<int> clearAllEvents() async {
    final db = await database;
    return await db.delete(_tableName);
  }

  // Close the database
  Future<void> close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }

  // Add methods to insert and retrieve settings
  Future<void> saveSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      _settingsTable,
      {
        _columnSettingKey: key,
        _columnSettingValue: value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final result = await db.query(
      _settingsTable,
      where: '$_columnSettingKey = ?',
      whereArgs: [key],
    );
    if (result.isNotEmpty) {
      return result.first[_columnSettingValue] as String;
    }
    return null;
  }
}
