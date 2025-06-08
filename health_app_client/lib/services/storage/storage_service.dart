// lib/services/storage/storage_service.dart
abstract class StorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
}