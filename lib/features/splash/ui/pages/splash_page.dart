// lib/features/splash/ui/pages/splash_page.dart
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key}); // Removido o parâmetro controller

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToCourseList();
  }

  Future<void> _navigateToCourseList() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/course-list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100, style: FlutterLogoStyle.stacked),
            const SizedBox(height: 24),
            const Text(
              'CEFIS LXP',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Plataforma de Aprendizado',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
