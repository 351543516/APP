// lib/api/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';  // 添加缺失的JSON解码库
import 'package:health_app_client/models/carousel_model.dart';

Future<List<CarouselModel>> fetchCarouselList() async {
  final response = await http.get(
    Uri.parse('http://8.153.201.207:8080/api/carousel/list'),
  );

  if (response.statusCode == 200) {
    // 添加类型转换和错误处理
    final List<dynamic> data = json.decode(response.body) as List;
    return data
        .cast<Map<String, dynamic>>()  // 确保类型转换安全
        .map((json) => CarouselModel.fromJson(json))
        .toList();
  } else {
    throw Exception('获取轮播图失败 (状态码：${response.statusCode})');
  }
}