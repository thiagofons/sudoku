import 'package:flutter/material.dart';
import 'package:sudoku/screens/game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  String _selectedDifficulty = 'easy';

  void _startGame() {
    if (_nicknameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira um apelido!")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          nickname: _nicknameController.text,
          difficulty: _selectedDifficulty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sudoku')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Digite seu apelido:"),
            TextField(controller: _nicknameController),
            const SizedBox(height: 20),
            const Text("Escolha a dificuldade:"),
            Column(
              children: ['easy', 'medium', 'hard', 'expert']
                  .map((level) => RadioListTile(
                        title: Text(level.toUpperCase()),
                        value: level,
                        groupValue: _selectedDifficulty,
                        onChanged: (value) {
                          setState(() => _selectedDifficulty = value!);
                        },
                      ))
                  .toList(),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _startGame,
                child: const Text('Iniciar Jogo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
