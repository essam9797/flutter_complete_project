import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/word_list_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'word_list_screen.dart';

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
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
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
                  color: _currentIndex == 0 ? Colors.indigo :Colors.grey,
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
                icon: Icon(
                  Icons.quiz, color: Colors.grey,
                ),
                onPressed: () {

                },
              ),
              IconButton(
                icon: Icon(
                  Icons.person, color: Colors.grey,
                ),
                onPressed: (){

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ddd'
              ),
            ],
          ),
        );
      },
    );
  }
}
     
