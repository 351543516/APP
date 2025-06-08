import 'package:flutter/material.dart';

class FeatureIconWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  FeatureIconWidget({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
          ),
          SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}