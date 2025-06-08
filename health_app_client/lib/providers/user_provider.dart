// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final List<User> _users = [];
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> addNewUser(User newUser) async {
    try {
      _startLoading();
      await _simulateApiCall();

      if (_users.any((u) => u.username == newUser.username)) {
        throw Exception('用户名已存在');
      }

      _users.add(newUser);
      _clearError();
    } catch (e) {
      _handleError('添加用户失败', e);
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> login(String username, String password) async {
    _startLoading();
    try {
      await _simulateApiCall();
      final user = _users.firstWhere(
            (u) => u.username == username && u.password == password,
        orElse: () => User.empty(), // ✅ 确保User类已定义empty()
      );

      if (user.id.isEmpty) throw Exception('用户名或密码错误');

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.id);
      _clearError();
    } catch (e) {
      _handleError('登录失败', e);
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    _currentUser = null;
    notifyListeners();
  }

  Future<User?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<User?> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    return userId != null ? getUserById(userId) : null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') != null;
  }

  Future<void> deleteUser(String userId) async {
    _startLoading();
    try {
      await _simulateApiCall();
      _users.removeWhere((user) => user.id == userId);
      _clearError();
    } catch (e) {
      _handleError('删除用户失败', e);
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() => _error = null;

  void _handleError(String prefix, dynamic e) {
    _error = '$prefix: ${e.toString().split(':').last.trim()}';
    debugPrint('⚠️ UserProvider Error: $_error');
  }

  // ✅ 明确指定泛型类型
  Future<void> _simulateApiCall() => Future<void>.delayed(const Duration(seconds: 1));
}