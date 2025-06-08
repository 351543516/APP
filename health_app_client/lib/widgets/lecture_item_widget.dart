import 'package:flutter/material.dart';

class LectureItemWidget extends StatelessWidget {
  final String title;
  final String views;
  final VoidCallback onTap;

  LectureItemWidget({
    required this.title,
    required this.views,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(views),
      onTap: onTap,
    );
  }
}