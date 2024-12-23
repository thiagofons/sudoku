import "package:sudoku/model/sudoku.dart";
import 'package:sudoku/repository/sudoku.dart';

class SudokuService {
  final SudokuRepository _repository = SudokuRepository();

  saveMatchInDatabase(SudokuModel game) async {
    await _repository.insertSudoku(game);
  }
}
