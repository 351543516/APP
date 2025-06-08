import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于页面'),
      ),
      body: Center(
        child: Text('这是关于页面，具体内容待补充'),
      ),
    );
  }
}