// lib/screens/health_record_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';

class HealthRecordPage extends StatelessWidget {
  final String userId;

  const HealthRecordPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健康档案'),
      ),
      body: FutureBuilder<User?>(
        future: Provider.of<UserProvider>(context, listen: false).getUserById(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('错误: ${snapshot.error}'));
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('用户不存在'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildInfoTile('用户ID', user.serverId?.toString() ?? '无'),
              _buildInfoTile('用户名', user.username),
              _buildInfoTile('性别', user.gender ?? '未设置'),
              _buildInfoTile('年龄', user.age?.toString() ?? '未设置'),
              _buildInfoTile('身高', _formatDouble(user.height)),
              _buildInfoTile('体重', _formatDouble(user.weight)),
              _buildInfoTile('过敏史', user.allergies.isNotEmpty ? user.allergies.join(', ') : '无'),
              _buildInfoTile('慢性病史', user.chronicDiseases.isNotEmpty ? user.chronicDiseases.join(', ') : '无'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value.isNotEmpty ? value : '--/--'),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  String _formatDouble(double? value) {
    return value?.toStringAsFixed(1) ?? '未测量';
  }
}