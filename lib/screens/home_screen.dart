import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/task_model.dart';
import 'package:flutter_application_3/screens/word_list_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_3/screens/quiz_words.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboardContent(),
    const WordsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_quick_actions_fab',
        backgroundColor: Colors.indigo,
        elevation: 6.h,
        onPressed: () {
          _showQuickActionSheet(context);
        },
        child: Icon(Icons.flash_on, color: Colors.white, size: 28.sp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 9.r,
        color: Colors.white,
        child: SizedBox(
          height: 60.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? Colors.indigo : Colors.grey,
                ),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
              IconButton(
                icon: Icon(
                  Icons.book,
                  color: _currentIndex == 1 ? Colors.indigo : Colors.grey,
                ),
                onPressed: () => setState(() => _currentIndex = 1),
              ),
              SizedBox(width: 40.w),
              IconButton(
                icon: Icon(Icons.quiz, color: Colors.grey),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizWords(
                        source: QuizSource.demo,
                        onSaveWord: (word) {
                          final normalizedWord = word.word.trim().toLowerCase();
                          final exists = WordsListScreen.dictionaryWords.any(
                            (item) =>
                                item.word.trim().toLowerCase() ==
                                normalizedWord,
                          );
                          if (exists) {
                            return false;
                          }
                          WordsListScreen.dictionaryWords.add(word);
                          return true;
                        },
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActionSheet(BuildContext context) {
    final nav = Navigator.of(context);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rapid procedures',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Icon(Icons.add_circle, color: Colors.indigo),
                title: Text('Add a new word quickly'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  nav.push(
                    MaterialPageRoute(
                      builder: (context) => const WordsListScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.quiz, color: Colors.teal),
                title: Text('Start a quick test'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  nav.push(
                    MaterialPageRoute(
                      builder: (context) => QuizWords(
                        source: QuizSource.dictionary,
                        dictionaryWords: WordsListScreen.dictionaryWords,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeDashboardContent extends StatelessWidget {
  const HomeDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Refresh Your Mind 🧠',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Column(
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Learn, Practice\nTake on challenges every day',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}