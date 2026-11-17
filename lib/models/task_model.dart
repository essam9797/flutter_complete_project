class TaskModel {
  String word = '';
  String meaning = '';
  String example = '';

  TaskModel({required this.word, required this.meaning, required this.example});

  factory TaskModel.fromJson(Map<String, dynamic>json) {
    return TaskModel(
      word: json['word'],
      meaning: json['meaning'],
      example: json['example'],
    );
  }
}