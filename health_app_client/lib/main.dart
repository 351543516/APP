// lib/main.dart 修正版本
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/my_page.dart';
import 'providers/user_provider.dart';
import 'screens/my_courses_screen.dart';
import 'screens/my_favorites_screen.dart';
import 'screens/points_center_screen.dart';
import 'screens/health_record_screen.dart';

void main() {
  debugDisableShadows = true;
  debugDisableClipLayers = true;

  runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/my': (context) => const MyPage(),
        '/my-courses': (context) => const MyCoursesScreen(),
        '/my-favorites': (context) => const MyFavoritesScreen(),
        '/points-center': (context) => const PointsCenterScreen(),
        '/health-record': (context) {
          final userId = ModalRoute.of(context)?.settings.arguments as int;
          return HealthRecordScreen(userId: userId);
        },
      },
    );
  }
}