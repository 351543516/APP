import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class FeatureIconWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;

  FeatureIconWidget({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = AppColors.secondaryColor,
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
            color: iconColor,
          ),
          SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}