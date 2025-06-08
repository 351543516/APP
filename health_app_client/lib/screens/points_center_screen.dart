// lib/screens/points_center_screen.dart
import 'package:flutter/material.dart';

class PointsCenterScreen extends StatelessWidget {
  const PointsCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('积分中心'),
      ),
      body: const Center(
        child: Text('这是积分中心页面'),
      ),
    );
  }
}