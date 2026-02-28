import 'package:cropvision/features/auth/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CropVisionApp());
}

class CropVisionApp extends StatelessWidget {
  const CropVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CropVision Login',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C7A4D),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8F2),
      ),
      home: const LoginPage(),
    );
  }
}
