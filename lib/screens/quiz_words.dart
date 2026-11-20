import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_3/models/task_model.dart';

enum QuizSource { demo, dictionary }

class QuizWords extends StatefulWidget {
  const QuizWords({
    super.key,
    required this.source,
    this.dictionaryWords = const [],
    this.onSaveWord,
  });

  final bool Function(TaskModel word)? onSaveWord;
  final QuizSource source;
  final List<TaskModel> dictionaryWords;

  @override
  State<QuizWords> createState() => _QuizWordsState();
}

class _QuizWordsState extends State<QuizWords> {
  static final Random _random = Random();
  static List<TaskModel>? _cachedDemoOrder;
  static List<TaskModel>? _cachedDictionaryOrder;
  static String? _lastDictionarySignature;

  final TextEditingController _answerController = TextEditingController();
  late List<TaskModel> _activeWords;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadQuizWords(forceShuffle: false);
  }

  String _buildDictionarySignature(List<TaskModel> list) {
    return list
        .map((e) => '${e.word.trim().toLowerCase()}|${e.meaning.trim()}')
        .join('||');
  }

  List<TaskModel> _cloneList(List<TaskModel> list) {
    return list
        .map(
          (item) => TaskModel(
            word: item.word,
            meaning: item.meaning,
            translation: item.translation,
          ),
        )
        .toList();
  }

  void _loadQuizWords({required bool forceShuffle}) {
    if (widget.source == QuizSource.demo) {
      final demoWords = [
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

      if (_cachedDemoOrder == null || forceShuffle) {
        final shuffled = _cloneList(demoWords);
        if (shuffled.length > 1) {
          shuffled.shuffle(_random);
        }
        _cachedDemoOrder = shuffled;
      }
      _activeWords = _cloneList(_cachedDemoOrder!);
    } else {
      final currentSignature = _buildDictionarySignature(widget.dictionaryWords);
      final dictionaryChanged = currentSignature != _lastDictionarySignature;

      if (_cachedDictionaryOrder == null ||
          dictionaryChanged ||
          forceShuffle) {
        final shuffled = _cloneList(widget.dictionaryWords);
        if (shuffled.length > 1) {
          shuffled.shuffle(_random);
        }
        _cachedDictionaryOrder = shuffled;
        _lastDictionarySignature = currentSignature;
      }

      _activeWords = _cloneList(_cachedDictionaryOrder!);
    }

    _currentIndex = 0;
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_activeWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.source == QuizSource.demo
                ? 'Quick Demo Challenge'
                : 'Friendly Dictionary Quiz',
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Text(
              'Your personal dictionary is empty. Add words first or try the quick demo challenge!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        ),
      );
    }

    if (_currentIndex >= _activeWords.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.source == QuizSource.demo
              ? 'Test Your Words 📝'
              : 'Friendly Dictionary Quiz 🖊️',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
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
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              child: TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  labelText: 'Word:',
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                if (_activeWords.isEmpty) return;
                final userAnswer = _answerController.text.trim().toLowerCase();
                final correctWord = _activeWords[_currentIndex].word
                    .trim()
                    .toLowerCase();

                if (userAnswer == correctWord) {
                  _answerController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Correct'),
                      duration: Duration(milliseconds: 700),
                    ),
                  );
                  if (_currentIndex < _activeWords.length - 1) {
                    setState(() {
                      _currentIndex++;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Great job'),
                        content: const Text(
                          'You finished all words in this quiz.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Exit'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.indigo,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _loadQuizWords(forceShuffle: true);
                              });
                            },
                            child: const Text(
                              'Restart',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Try again'),
                      duration: Duration(milliseconds: 700),
                    ),
                  );
                }
              },
              child: const Text('Check', style: TextStyle(color: Colors.white)),
            ),
            if (widget.source == QuizSource.demo) ...[
              SizedBox(height: 10.h),
              OutlinedButton.icon(
                onPressed: () {
                  if (_activeWords.isEmpty) return;
                  final currentWord = _activeWords[_currentIndex];
                  final savedCopy = TaskModel(
                    word: currentWord.word,
                    meaning: currentWord.meaning,
                    translation: currentWord.translation,
                  );
                  final wasSaved = widget.onSaveWord?.call(savedCopy) ?? false;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        wasSaved
                            ? 'Saved "${currentWord.word}" to your dictionary'
                            : '"${currentWord.word}" is already in your dictionary',
                      ),
                      duration: const Duration(milliseconds: 900),
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark_add_outlined),
                label: const Text('Save to my dictionary'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}