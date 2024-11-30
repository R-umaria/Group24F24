// File path: lib/database_helper.dart
// Handles SQLite database for storing trip data

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  // Database table and column names
  static const String _tableName = 'trip_events';
  static const String _columnId = 'id';
  static const String _columnEventType = 'event_type';
  static const String _columnTimestamp = 'timestamp';
  static const String _columnLatitude = 'latitude';
  static const String _columnLongitude = 'longitude';
  static const String _columnSpeed = 'speed';

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'drivewise.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnEventType TEXT NOT NULL,
        $_columnTimestamp TEXT NOT NULL,
        $_columnLatitude REAL NOT NULL,
        $_columnLongitude REAL NOT NULL,
        $_columnSpeed REAL NOT NULL
      )
    ''');
  }

  // Insert a new event into the database
  Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    return await db.insert(_tableName, event);
  }

  // Retrieve all events from the database
  Future<List<Map<String, dynamic>>> getAllEvents() async {
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

  // Clear all data (for debugging or testing purposes)
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
}
