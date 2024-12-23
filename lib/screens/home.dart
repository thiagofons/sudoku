import 'package:flutter/material.dart';
import 'package:sudoku/screens/game.dart';
import 'package:sudoku/screens/my_games.dart';

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

  void _goToMyGames() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyGamesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> translations = {
      "easy": "fácil",
      "medium": "normal",
      "hard": "difícil",
      "expert": "expert"
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Campo de texto para o apelido
                const Text(
                  "Digite seu apelido:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nicknameController,
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Apelido',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                  ),
                ),
                const SizedBox(height: 32),

                // Seletor de dificuldade
                const Text(
                  "Escolha a dificuldade:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Column(
                  children: ['easy', 'medium', 'hard', 'expert']
                      .map(
                        (level) => Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                checkmarkColor: Colors.white,
                                label: Text(
                                  translations[level]!.toUpperCase(),
                                  style: TextStyle(
                                    color: _selectedDifficulty == level
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                selected: _selectedDifficulty == level,
                                onSelected: (selected) {
                                  setState(() => _selectedDifficulty = level);
                                },
                                selectedColor: Colors.blue,
                                backgroundColor: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 32),

                // Botão para iniciar o jogo
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Iniciar Jogo',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: _goToMyGames,
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Meus Jogos',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
