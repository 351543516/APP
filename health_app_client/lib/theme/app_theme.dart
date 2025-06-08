import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.techBlue, // 修改为 techBlue
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.techBlue, // 修改为 techBlue
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.techBlue, // 修改为 techBlue
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkBrown), // 修改为 darkBrown
    ),
  );
}