// //andy guest - dec 02 2024
// //database for the behaviour analysis and trip info
// //if you want to learn abt the database -> https://docs.flutter.dev/cookbook/persistence/sqlite

// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import '../speed_analysis.dart';

// class BehaviourAnalysisDatabase {
//   static final BehaviourAnalysisDatabase _instance = BehaviourAnalysisDatabase._internal();
//   factory BehaviourAnalysisDatabase() => _instance;

//   static Database? _database;

//   BehaviourAnalysisDatabase._internal();

//   //database instance
//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDatabase();
//     return _database!;
//   }

//   //initilize the db
//   Future<Database> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     return openDatabase(
//       join(dbPath, 'tripInfo1.db'),
//       onCreate: (db, version) {
//         //create tables
//         return db.execute(
//           //speed only rn
//           'CREATE TABLE behaviourAnalysis(id INTEGER PRIMARY KEY, warningSpeedPercent DOUBLE, dangerSpeedPercent DOUBLE, safeSpeedPercent DOUBLE)',
//         );
//       },
//       version: 1,
//     );
//   }

//   //to put data into db
//   Future<void> insertBehaviourAnalysisInfo(behaviourAnalysisInfo behaviourAnalysis) async {
//     final db = await database;
//     await db.insert(
//       'behaviourAnalysis',
//       behaviourAnalysis.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   //retrieve all behaviour analysis info from the database
//   Future<List<behaviourAnalysisInfo>> getTripInfo() async {
//     final db = await database;
//     final List<Map<String, Object?>> dogMaps = await db.query('behaviourAnalysis');
    
//     return dogMaps.map((map) {
//       return behaviourAnalysisInfo(
//         id: map['id'] as int,
//         warningSpeedPercent: map['warningSpeedPercent'] as double,
//         dangerSpeedPercent: map['dangerSpeedPercent'] as double,
//         safeSpeedPercent: map['safeSpeedPercent'] as double,
//       );
//     }).toList();
//   }

//   //retrieve a specific behaviour analysis info by ID
//   Future<behaviourAnalysisInfo?> getBehaviourAnalysisInfoById(int id) async {
//     final db = await database;
//     final List<Map<String, Object?>> maps = await db.query(
//       'behaviourAnalysis',
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (maps.isEmpty) {
//       return null;
//     }

//     final map = maps.first;
//     return behaviourAnalysisInfo(
//       id: map['id'] as int,
//       warningSpeedPercent: map['warningSpeedPercent'] as double,
//       dangerSpeedPercent: map['dangerSpeedPercent'] as double,
//       safeSpeedPercent: map['safeSpeedPercent'] as double,
//     );
//   }
// }
