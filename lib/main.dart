// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lxp_platform/core/di/service_locator.dart';
import 'package:lxp_platform/core/theme/app_theme.dart';
import 'package:lxp_platform/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configura injeção de dependência e aguarda conclusão
  await setupServiceLocator();

  runApp(const LXPPlatform());
}

class LXPPlatform extends StatelessWidget {
  const LXPPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEFIS LXP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
