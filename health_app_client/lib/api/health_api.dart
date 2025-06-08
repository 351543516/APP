// lib/api/health_api.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/health_record.dart';

const String baseUrl = 'http://8.153.201.207:8080';

Future<HealthRecord> getHealthRecord(int userId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/health/record/$userId'),
      headers: {'Authorization': 'Bearer <TOKEN>'}, // 需添加认证头
    );
    if (response.statusCode == 200) {
      return HealthRecord.fromJson(json.decode(response.body));
    } else {
      throw Exception('获取健康档案失败: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('网络错误: $e');
  }
}