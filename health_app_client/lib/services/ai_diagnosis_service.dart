import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class AIDiagnosisService {
  static Future<Map<String, dynamic>> diagnose(XFile? image, Map<String, String> answers) async {
    // 模拟一个简单的诊断结果
    Map<String, dynamic> mockDiagnosisResult = {
      "condition": "健康状况良好",
      "suggestion": "保持当前的生活习惯",
      "confidence": 0.9
    };

    // 模拟网络请求延迟
    await Future.delayed(const Duration(seconds: 2));

    return mockDiagnosisResult;
  }
}