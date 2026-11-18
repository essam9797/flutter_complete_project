import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_3/models/task_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<TaskModel> wordList = [
    TaskModel(
      word: 'Short',
      meaning: 'small in length, height, or duration (time), or not having enough of something',
      example: 'قصير',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Refresh your mind 🧠',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 191, 205, 212),
        elevation: 4.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16.r),
          )
        ),
      ),
      body: ListView.builder(
        itemCount: wordList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text(wordList[index].word.toString())),
            title: Text(wordList[index].meaning),
            subtitle: Text(wordList[index].example),
            trailing: ElevatedButton(onPressed: () {}, child: Text('Edit')),
          );
        },
      ),
    );
  }
}
