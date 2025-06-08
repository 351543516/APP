// lib/screens/my_courses_screen.dart
import 'package:flutter/material.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的课程'),
      ),
      body: const Center(
        child: Text('这是我的课程页面'),
      ),
    );
  }
}