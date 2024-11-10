import 'package:flutter/material.dart';
import 'package:sudoku/screens/home.dart';

void main() => runApp(const SudokuApp());

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Game',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
