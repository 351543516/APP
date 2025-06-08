import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商城页面'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(
        child: Text('这是商城页面'),
      ),
    );
  }
}