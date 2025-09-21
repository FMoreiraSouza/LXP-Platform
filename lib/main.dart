import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lxp_platform/core/theme/app_theme.dart';
import 'package:lxp_platform/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const CefisLxpApp());
}

class CefisLxpApp extends StatelessWidget {
  const CefisLxpApp({super.key});

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
