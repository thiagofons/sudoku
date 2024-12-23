import 'dart:io' as io;

import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sudoku/model/sudoku.dart';

var logger = Logger();

class SudokuRepository {
  late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    final path = p.join(appDocumentsDir.path, "databases", "banco.db");

    Database db = await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              String sql = """
              CREATE TABLE sudokus (
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  name TEXT, 
                  result INTEGER, 
                  date TEXT, 
                  level INTEGER
              );
              """;
              await db.execute(sql);
            }));
    return db;
  }

  Future<void> insertSudoku(SudokuModel sudoku) async {
    final db = await database;

    try {
      await db.insert(
        'sudokus',
        sudoku.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      logger.e("Error inserting sudoku: $e");
    }
  }

  Future<List<SudokuModel>> getSudokus() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('sudokus');

      return List.generate(maps.length, (i) {
        return SudokuModel.fromMap(maps[i]);
      });
    } catch (e) {
      logger.e("Error fetching sudokus: $e");
      return [];
    }
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
