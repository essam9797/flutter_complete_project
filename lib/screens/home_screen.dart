import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/task_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<TaskModel> y =  [
    TaskModel(id: 1, title: 'اول مهمة'),
    TaskModel(id: 2, title: 'ثاني مهمة'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المهام'),
      ),
      body: ListView.builder(
        itemCount: y.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(y[index].id.toString()),
            ),
            title: Text(y[index].title),
          );
        },
      ),
    );
  }
}