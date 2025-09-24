import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lxp_platform/core/di/service_locator.dart';
import 'package:lxp_platform/core/theme/app_theme.dart';
import 'package:lxp_platform/routes/app_routes_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

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

      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,

      initialRoute: AppRoutesManager.splash,
      onGenerateRoute: AppRoutesManager.generateRoute,

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(platformBrightness: Brightness.dark),
          child: child!,
        );
      },
    );
  }
}
