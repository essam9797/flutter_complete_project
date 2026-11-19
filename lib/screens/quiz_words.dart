import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_3/models/task_model.dart';
import 'package:flutter_application_3/screens/word_list_screen.dart';

enum QuizSource { demo, dictionary }

class QuizWords extends StatefulWidget{
  const QuizWords({
    super.key,
    required this.source,
    this.dictionaryWords = const [],
  });

  final QuizSource source;
  final List<TaskModel> dictionaryWords;


  @override
  State<QuizWords> createState() => _QuizWordsState();
}

class _QuizWordsState extends State<QuizWords> {

  int _currentIndex = 0;
  late List<TaskModel> _activeWords;

  @override
  void initState() {
    super.initState();

    if (widget.source == QuizSource.demo) {
      _activeWords = [
        TaskModel(
      word: 'eager',
      meaning: 'having or showing keen interest or enthusiasm',
      translation: 'متحمس أو متلهف',
    ),
    TaskModel(
      word: 'brief',
      meaning: 'of short duration; not lasting for long',
      translation: 'مختصر أو وجيز',
    ),
    TaskModel(
      word: 'hesitate',
      meaning: 'pause before saying or doing something',
      translation: 'يتردد',
    ),
      ];
    } else {
      _activeWords = widget.dictionaryWords;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.source == QuizSource.demo ? 'Test Your Words 📝' : 'My Dictionary Quiz',
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
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                _activeWords[_currentIndex].meaning,
                style: TextStyle(fontSize: 18.sp),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 18.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  labelText: 'Word'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}