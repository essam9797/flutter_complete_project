class TaskModel {
  int id = 0;
  String title = '';

  TaskModel({required this.id, required this.title});

  factory TaskModel.fromJson(Map<String, dynamic>json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
    );
  }
}