import 'package:flutter/material.dart';
import 'package:sudoku/model/sudoku.dart';
import 'package:sudoku/service/sudoku.dart';

class MyGamesScreen extends StatefulWidget {
  const MyGamesScreen({super.key});

  @override
  _MyGamesScreenState createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  final SudokuService _sudokuService = SudokuService();
  late Future<List<SudokuModel>> _gamesFuture;
  List<int> _selectedDifficulties = [0, 1, 2, 3];

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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar por Dificuldade'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: levels.entries.map((entry) {
                  return CheckboxListTile(
                    title: Text(entry.value),
                    value: _selectedDifficulties.contains(entry.key),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedDifficulties.add(entry.key);
                        } else {
                          _selectedDifficulties.remove(entry.key);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Jogos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
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
            final games = snapshot.data!
                .where((game) => _selectedDifficulties.contains(game.level))
                .toList();
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return ListTile(
                  title: Text(game.name),
                  subtitle: Text(
                      'Resultado: ${results[game.result]}, Data: ${game.date}, Nível: ${levels[game.level]}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
