// lib/services/storage/storage_service_impl.dart
import 'storage_service.dart';

class StorageServiceImpl implements StorageService {
  static const _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    // 实现保存token的逻辑
  }

  @override
  Future<String?> getToken() async {
    // 实现获取token的逻辑
    return 'test_token'; // 临时返回测试值
  }
}