import 'package:sudoku/model/sudoku.dart';
import 'package:sudoku/repository/sudoku.dart';

class SudokuService {
  final SudokuRepository _repository = SudokuRepository();

  Future<void> saveMatchInDatabase(SudokuModel game) async {
    await _repository.insertSudoku(game);
  }

  Future<List<SudokuModel>> getAllMatches() async {
    print("Service");
    return await _repository.getSudokus();
  }
}
