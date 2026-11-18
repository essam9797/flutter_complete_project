class TaskModel {
  String word = '';
  String meaning = '';
  String translation = '';

  TaskModel({required this.word, required this.meaning, required this.translation});

  factory TaskModel.fromJson(Map<String, dynamic>json) {
    return TaskModel(
      word: json['word'],
      meaning: json['meaning'],
      translation: json['translation'],
    );
  }
}