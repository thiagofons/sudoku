import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sudoku/model/sudoku.dart';

class SudokuRepository {
  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sudoku_database.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE sudokus(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, result INTEGER, date TEXT, level INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertSudoku(SudokuModel sudoku) async {
    final db = await database;
    await db.insert(
      'sudokus',
      sudoku.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SudokuModel>> getSudokus() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sudokus');

    return List.generate(maps.length, (i) {
      return SudokuModel.fromMap(maps[i]);
    });
  }
}
