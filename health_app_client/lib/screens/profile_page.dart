// lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userProfile;
  String? _error;

  final ApiService _apiService = ApiService();

  Future<void> _loadProfile() async {
    try {
      final response = await _apiService.get('/api/v1/user/profile');
      setState(() => _userProfile = response.data);
    } on DioException catch (e) {
      setState(() => _error = '获取用户信息失败: ${e.response?.data?['message']}');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return Text(_error!);
    if (_userProfile == null) return CircularProgressIndicator();

    return Column(
      children: [
        Text(_userProfile!['name']),
        Text(_userProfile!['phone']),
      ],
    );
  }
}