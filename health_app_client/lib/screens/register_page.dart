import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/color_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  int _countdown = 0;
  Timer? _timer;
  String? phoneError;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_phoneController.text.length != 11) {
      setState(() => phoneError = '手机号码输入有误，请重新输入');
      return;
    }
    setState(() {
      phoneError = null;
      _isOtpSent = true;
      _countdown = 60;
      _startCountdown();
    });
    print('发送验证码到 ${_phoneController.text}');
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _countdown > 0 ? _countdown-- : _timer?.cancel());
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canRegister = _otpController.text.isNotEmpty && _countdown == 0;
    final bool canGetOtp = _phoneController.text.length == 11 && !_isOtpSent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
        backgroundColor: Color(0xFF2B3D86),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFF5F7FA),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 50),
          child: Column(
            children: [
              TextField(
                controller: _phoneController,
                decoration: _inputDecoration('请输入手机号'),
                style: TextStyle(fontSize: 16),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                onChanged: (value) => setState(() {
                  if (value.length == 11) phoneError = null;
                }),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _otpController,
                decoration: _inputDecoration('请输入验证码'),
                style: TextStyle(fontSize: 16),
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                enabled: _isOtpSent,
                onChanged: (value) => setState(() {}),
              ),
              if (phoneError != null)
                Text(phoneError!, style: TextStyle(color: Colors.red, fontSize: 14)),
              if (_isOtpSent && _countdown > 0)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('$_countdown 秒后重新获取',
                      style: TextStyle(color: Colors.red, fontSize: 14)),
                ),
              SizedBox(height: 40),
              // 动态按钮
              _isOtpSent
                  ? _buildRegisterButton(canRegister)
                  : _buildGetOtpButton(canGetOtp),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(color: Color(0xFF2B3D86), width: 1.2),
                  ),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/wechat_icon.png', width: 24, height: 24),
                    SizedBox(width: 12),
                    Text('微信一键登录',
                        style: TextStyle(color: Color(0xFF2B3D86), fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 复用输入框样式
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2B3D86), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  // 注册按钮
  ElevatedButton _buildRegisterButton(bool enabled) {
    return ElevatedButton(
      onPressed: _otpController.text.isNotEmpty ? () => print('执行注册') : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2B3D86),
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Color(0xFF2B3D86),
            width: 1.2,
          ),
        ),
        minimumSize: Size(double.infinity, 48),
        disabledBackgroundColor: withCustomOpacity(0xFF2B3D86, 0.6),
        disabledForegroundColor: withCustomOpacity(0xFFFFFFFF, 0.6),
      ),
      child: Text(
        '注册',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  // 获取验证码按钮
  ElevatedButton _buildGetOtpButton(bool enabled) {
    return ElevatedButton(
      onPressed: enabled ? _sendOtp : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? Color(0xFF2B3D86) : Colors.grey.shade300,
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: enabled ? Color(0xFF2B3D86) : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        minimumSize: Size(double.infinity, 48),
      ),
      child: Text('获取验证码/注册',
          style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}