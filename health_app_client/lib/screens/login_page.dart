import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
        backgroundColor: const Color(0xFF2B3D86),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF5F7FA),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '用户名',
                  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  enabledBorder: _buildBorder(Colors.grey.shade300!),
                  focusedBorder: _buildBorder(const Color(0xFF2B3D86)),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密码',
                  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  enabledBorder: _buildBorder(Colors.grey.shade300!),
                  focusedBorder: _buildBorder(const Color(0xFF2B3D86)),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B3D86),
                  padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('登录', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.2),
      borderRadius: BorderRadius.circular(16),
    );
  }

  void _handleLogin() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
  }
}