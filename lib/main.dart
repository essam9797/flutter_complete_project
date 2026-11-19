import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/quiz_words.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_3/screens/home_screen.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext build) {
        return ScreenUtilInit(
            designSize: const Size(360, 390),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: '',
                    theme: ThemeData(
                        primarySwatch: Colors.blue,
                    ),
                    home:  HomeScreen(),
                );
            }
        );
    }
}