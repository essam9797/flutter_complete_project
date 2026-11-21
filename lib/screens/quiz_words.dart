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

  bool _showSuccessBadge = false;
  bool _awaitingContinue = false;
  String _encouragementMessage = '';

  static const List<String> _duoMessages = [
    'Awesome! Keep that streak going 🔥',
    'Spot on! Ready for the next one?',
    'Great job! You’re crushing it 💪',
    'Nice work! Let’s keep moving ✨',
  ];

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
          meaning: 'of short duration, not lasting for long',
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
    _showSuccessBadge = false;
    _awaitingContinue = false;
  }

  void _triggerSuccessFeedback() {
    final msg = _duoMessages[_random.nextInt(_duoMessages.length)];
    setState(() {
      _showSuccessBadge = true;
      _awaitingContinue = true;
      _encouragementMessage = msg;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _showSuccessBadge = false;
      });
    });
  }

  void _proceedAfterCorrectAnswer() {
    _answerController.clear();
    if (_currentIndex < _activeWords.length - 1) {
      setState(() {
        _currentIndex++;
        _awaitingContinue = false;
        _showSuccessBadge = false;
      });
    } else {
      setState(() {
        _awaitingContinue = false;
        _showSuccessBadge = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Great job'),
          content: const Text('You finished all words in this quiz.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.indigo),
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
  }

  void _handleCheckPressed() {
    if (_activeWords.isEmpty || _awaitingContinue) return;

    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctWord = _activeWords[_currentIndex].word.trim().toLowerCase();

    if (userAnswer == correctWord) {
      _triggerSuccessFeedback();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Try again'),
          duration: Duration(milliseconds: 700),
        ),
      );
    }
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

    final currentWordItem = _activeWords[_currentIndex];

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.08),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Container(
                    key: ValueKey(
                      '${_currentIndex}_${currentWordItem.word}',
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.indigo.shade100),
                    ),
                    child: Text(
                      currentWordItem.meaning,
                      style: TextStyle(fontSize: 18.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: TextField(
                    controller: _answerController,
                    enabled: !_awaitingContinue,
                    onSubmitted: (_) => _handleCheckPressed(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      labelText: 'Word:',
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                if (!_awaitingContinue)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                    onPressed: _handleCheckPressed,
                    child: const Text(
                      'Check',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (widget.source == QuizSource.demo && !_awaitingContinue) ...[
                  SizedBox(height: 10.h),
                  OutlinedButton.icon(
                    onPressed: () {
                      final savedCopy = TaskModel(
                        word: currentWordItem.word,
                        meaning: currentWordItem.meaning,
                        translation: currentWordItem.translation,
                      );
                      final wasSaved =
                          widget.onSaveWord?.call(savedCopy) ?? false;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            wasSaved
                                ? 'Saved "${currentWordItem.word}" to your dictionary'
                                : '"${currentWordItem.word}" is already in your dictionary',
                          ),
                          duration: const Duration(milliseconds: 900),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Save to my dictionary'),
                  ),
                ],
                if (_awaitingContinue) ...[
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                              size: 22.sp,
                            ),
                            SizedBox(width: 8.w),
                            Flexible(
                              child: Text(
                                _encouragementMessage,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                            ),
                            onPressed: _proceedAfterCorrectAnswer,
                            child: const Text(
                              'Continue',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          IgnorePointer(
            child: Center(
              child: AnimatedOpacity(
                opacity: _showSuccessBadge ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 220),
                child: AnimatedScale(
                  scale: _showSuccessBadge ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.elasticOut,
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.3),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 48.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}