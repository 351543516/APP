// lib/screens/add_user_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key}); // 修复key参数语法

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _selectedGender; // 改为使用状态管理性别
  final _ageController = TextEditingController();

  static const List<String> _genderOptions = ['男', '女'];

  // 添加ID生成方法
  String _generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final newUser = User(
      id: _generateUserId(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      gender: _selectedGender, // 使用正确的字段名称
      age: int.tryParse(_ageController.text.trim()),
      // 初始化新增字段
      allergies: [],
      chronicDiseases: [],
    );

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .addNewUser(newUser);

      if (!mounted) return;

      Navigator.pop(context); // 简化导航返回

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('用户添加成功'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('添加失败：${e.toString().split(':').last}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加用户'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _usernameController,
                label: '用户名',
                validator: (v) => v?.isEmpty ?? true ? '请输入用户名' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                label: '密码',
                obscureText: true,
                validator: (v) {
                  if (v?.isEmpty ?? true) return '请输入密码';
                  if (v!.length < 6) return '密码至少6位';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: '姓名',
                validator: (v) => v?.isEmpty ?? true ? '请输入姓名' : null,
              ),
              const SizedBox(height: 16),
              _buildGenderDropdown(),
              const SizedBox(height: 16),
              _buildAgeInput(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('提交', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: validator,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: const ['男', '女'] // 使用const声明
          .map((gender) => DropdownMenuItem(
        value: gender,
        child: Text(gender),
      ))
          .toList(),
      onChanged: (value) => setState(() => _selectedGender = value),
      decoration: const InputDecoration(
        labelText: '性别',
        border: OutlineInputBorder(),
      ),
      validator: (v) => v == null ? '请选择性别' : null,
    );
  }

  Widget _buildAgeInput() {
    return TextFormField(
      controller: _ageController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: '年龄',
        border: OutlineInputBorder(),
      ),
      validator: (v) {
        if (v?.isEmpty ?? true) return '请输入年龄';
        final number = int.tryParse(v!);
        if (number == null) return '请输入有效数字';
        if (number < 0 || number > 150) return '年龄应在0-150之间';
        return null;
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}