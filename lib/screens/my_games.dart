import 'package:flutter/material.dart';
import 'package:sudoku/model/sudoku.dart';
import 'package:sudoku/service/sudoku.dart';

class MyGamesScreen extends StatefulWidget {
  const MyGamesScreen({super.key});

  @override
  State<MyGamesScreen> createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  final SudokuService _sudokuService = SudokuService();
  late Future<List<SudokuModel>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _gamesFuture = _sudokuService.getAllMatches();
  }

  Map<int, String> results = {
    0: 'Incompleto',
    1: 'Completo',
  };

  Map<int, String> levels = {
    0: 'Fácil',
    1: 'Normal',
    2: 'Difícil',
    3: 'Expert',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Jogos'),
      ),
      body: FutureBuilder<List<SudokuModel>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os jogos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum jogo encontrado.'));
          } else {
            final games = snapshot.data!;
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return ListTile(
                  title: Text(
                    game.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resultado: ${results[game.result]}'),
                      Text('Data: ${game.date}'),
                      Text('Dificuldade: ${levels[game.level]}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
