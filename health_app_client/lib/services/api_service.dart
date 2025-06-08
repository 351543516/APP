// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'storage/storage_service.dart';
import 'storage/storage_service_impl.dart';
import 'token_interceptor.dart';

class ApiService {
  final Dio _dio;
  final StorageService _storageService;

  ApiService()
      : _dio = Dio(),
        _storageService = StorageServiceImpl() {
    _dio.interceptors.add(TokenInterceptor(storageService: _storageService));
  }

  Future<Response<dynamic>> get(String endpoint) async {
    return _dio.get<dynamic>(endpoint);
  }

  Future<Response<dynamic>> post(String endpoint, dynamic data) async {
    return _dio.post<dynamic>(endpoint, data: data);
  }
}