class SudokuModel {
  final int? id;
  final String name;
  final int result;
  final String date;
  final int level;

  SudokuModel(
      {this.id,
      required this.name,
      required this.result,
      required this.date,
      required this.level});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'result': result,
      'date': date,
      'level': level,
    };
  }

  factory SudokuModel.fromMap(Map<String, dynamic> map) {
    return SudokuModel(
      id: map['id'],
      name: map['name'],
      result: map['result'],
      date: map['date'],
      level: map['level'],
    );
  }
}
