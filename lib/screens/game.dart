import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class GameScreen extends StatefulWidget {
  final String nickname;
  final String difficulty;

  const GameScreen(
      {super.key, required this.nickname, required this.difficulty});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Sudoku _sudoku;
  late List<int> _board;
  late List<int> _solution;

  @override
  void initState() {
    super.initState();
    _generateBoard();
  }

  // Gera o tabuleiro com base no nível de dificuldade escolhido
  void _generateBoard() {
    final level = {
      'easy': Level.easy,
      'medium': Level.medium,
      'hard': Level.hard,
      'expert': Level.expert,
    }[widget.difficulty]!;

    _sudoku = Sudoku.generate(level);
    _board = List<int>.from(_sudoku.puzzle);
    _solution = List<int>.from(_sudoku.solution);
  }

  // Verifica se um número pode ser inserido na posição especificada
  bool _isValidMove(int index, int num) {
    int row = index ~/ 9;
    int col = index % 9;

    // Verificar linha
    for (int i = 0; i < 9; i++) {
      if (_board[row * 9 + i] == num) return false;
    }
    // Verificar coluna
    for (int i = 0; i < 9; i++) {
      if (_board[i * 9 + col] == num) return false;
    }
    // Verificar bloco 3x3
    int startRow = row ~/ 3 * 3;
    int startCol = col ~/ 3 * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int blockIndex = (startRow + i) * 9 + (startCol + j);
        if (_board[blockIndex] == num) return false;
      }
    }
    return true;
  }

  void _checkCompletion() {
    // Só verificar a solução se todas as células estiverem preenchidas
    if (!_board.contains(-1)) {
      bool isCorrect = true;
      for (int i = 0; i < 81; i++) {
        if (_board[i] != _solution[i]) {
          isCorrect = false;
          break;
        }
      }
      // Mostrar uma mensagem apenas se o tabuleiro estiver correto ou incorreto
      String message = isCorrect
          ? "Parabéns, você completou o jogo corretamente!"
          : "O tabuleiro não está correto. Tente novamente!";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jogador: ${widget.nickname}')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                childAspectRatio: 1,
              ),
              itemCount: 81,
              itemBuilder: (context, index) {
                bool isInitial = _sudoku.puzzle[index] != -1;
                int value = _board[index];

                // Cálculo das linhas e colunas
                int row = index ~/ 9;
                int col = index % 9;

                // Definir espessura das bordas com base na posição para separar blocos 3x3
                double leftBorder = col % 3 == 0 ? 3.0 : 0.5;
                double rightBorder = (col + 1) % 3 == 0 ? 3.0 : 0.5;
                double topBorder = row % 3 == 0 ? 3.0 : 0.5;
                double bottomBorder = (row + 1) % 3 == 0 ? 3.0 : 0.5;

                return GestureDetector(
                    onTap: () {
                      if (!isInitial) {
                        _showNumberInputDialog(context, index);
                      }
                    },
                    child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: leftBorder, color: Colors.black),
                            right: BorderSide(
                                width: rightBorder, color: Colors.black),
                            top: BorderSide(
                                width: topBorder, color: Colors.black),
                            bottom: BorderSide(
                                width: bottomBorder, color: Colors.black),
                          ),
                          color: isInitial ? Colors.grey[300] : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          value != -1 ? value.toString() : '',
                          style: TextStyle(
                            fontSize: 20,
                            color: isInitial ? Colors.black : Colors.blue,
                          ),
                        )));
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(_generateBoard);
            },
            child: const Text('Novo Jogo'),
          ),
        ],
      ),
    );
  }

  // Abre um diálogo para inserir um número
  // Abre um diálogo para inserir um número
  Future<void> _showNumberInputDialog(BuildContext context, int index) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Insira um número (1-9)"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Número"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                int? num = int.tryParse(controller.text);

                // Verifica se o número é válido (entre 1 e 9) e se é um movimento permitido
                if (num != null && num >= 1 && num <= 9) {
                  if (_isValidMove(index, num)) {
                    setState(() {
                      _board[index] = num;
                    });
                    _checkCompletion();
                    Navigator.of(context)
                        .pop(); // Fecha o diálogo apenas se o movimento for válido
                  } else {
                    // Exibe uma mensagem de erro se o número for inválido para aquela posição
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Número inválido para esta posição!")),
                    );
                  }
                } else {
                  // Exibe uma mensagem de erro se o número digitado for inválido (não entre 1 e 9)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Por favor, insira um número entre 1 e 9")),
                  );
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
