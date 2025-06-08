// lib/screens/health_record_screen.dart
import 'package:flutter/material.dart';

class HealthRecordScreen extends StatelessWidget {
  final int userId;

  const HealthRecordScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健康档案'),
      ),
      body: Center(
        child: Text('这是用户 $userId 的健康档案页面'),
      ),
    );
  }
}