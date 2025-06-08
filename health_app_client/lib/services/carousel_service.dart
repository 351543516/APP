// lib/services/carousel_service.dart
import 'package:http/http.dart' as http;
import 'package:health_app_client/models/carousel_model.dart';
import '../constants/api_constants.dart';
import 'dart:convert';
import 'dart:async';

class CarouselService {
  static const _timeout = Duration(seconds: 15);

  /// 获取轮播图数据
  static Future<List<CarouselModel>> fetchCarouselList() async {
    try {
      final uri = Uri.parse(ApiConstants.carouselList);
      final response = await http.get(uri).timeout(_timeout);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw _CarouselException('网络连接失败: ${e.message}');
    } on TimeoutException catch (_)  {
      throw _CarouselException('请求超时，请检查网络连接');
    } on FormatException {
      throw _CarouselException('数据解析失败');
    } catch (e) {
      throw _CarouselException('未知错误: ${e.runtimeType}');
    }
  }

  /// 处理HTTP响应
  static List<CarouselModel> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return _parseResponseData(response.body);
      case 401:
        throw _CarouselException('身份验证失败，请重新登录');
      case 404:
        throw _CarouselException('资源未找到');
      case 500:
        throw _CarouselException('服务器内部错误');
      default:
        throw _CarouselException(
          '请求失败，状态码: ${response.statusCode}',
          code: response.statusCode,
        );
    }
  }

  /// 解析响应数据
  static List<CarouselModel> _parseResponseData(String body) {
    try {
      final List<dynamic> data = json.decode(body)['data'] ?? [];
      return data.map((json) => CarouselModel.fromJson(json)).toList();
    } on FormatException {
      throw _CarouselException('无效的JSON格式');
    } on TypeError catch (e) {
      throw _CarouselException('数据格式错误: ${e.stackTrace}');
    }
  }
}

/// 自定义业务异常
class _CarouselException implements Exception {
  final String message;
  final int? code;

  const _CarouselException(this.message, {this.code});

  @override
  String toString() => 'CarouselServiceError[$code]: $message';
}