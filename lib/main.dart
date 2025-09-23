import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lxp_platform/core/di/service_locator.dart';
import 'package:lxp_platform/core/theme/app_theme.dart';
import 'package:lxp_platform/routes/app_routes_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await setupServiceLocator();

  runApp(const LXPPlatform());
}

class LXPPlatform extends StatelessWidget {
  const LXPPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LXP Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutesManager.splash,
      onGenerateRoute: AppRoutesManager.generateRoute,
    );
  }
}
