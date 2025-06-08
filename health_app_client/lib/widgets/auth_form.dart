// lib/widgets/auth_form.dart
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final Function(String phone, String password, [String? name]) onSubmit;

  const AuthForm({
    Key? key,
    required this.isLogin,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _phone = '';
  String _password = '';
  String _name = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_phone, _password, widget.isLogin ? null : _name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 手机号输入
          TextFormField(
            decoration: const InputDecoration(labelText: '手机号'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入手机号';
              }
              if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                return '请输入有效的手机号';
              }
              return null;
            },
            onSaved: (value) => _phone = value!,
          ),

          const SizedBox(height: 16),

          // 密码输入
          TextFormField(
            decoration: const InputDecoration(labelText: '密码'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入密码';
              }
              if (value.length < 6) {
                return '密码长度至少6位';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
          ),

          if (!widget.isLogin) ...[
            const SizedBox(height: 16),
            // 姓名输入（仅注册时显示）
            TextFormField(
              decoration: const InputDecoration(labelText: '姓名'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入姓名';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
          ],

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.isLogin ? '登录' : '注册'),
          ),
        ],
      ),
    );
  }
}