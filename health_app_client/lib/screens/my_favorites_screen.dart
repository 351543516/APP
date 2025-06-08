import 'package:flutter/material.dart';

class MyFavoritesScreen extends StatelessWidget {
  const MyFavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: const Center(child: Text('我的收藏页面')),
    );
  }
}