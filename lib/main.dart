import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lxp_platform/core/di/service_locator.dart';
import 'package:lxp_platform/core/theme/app_theme.dart';
import 'package:lxp_platform/routes/app_routes_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurações do sistema para Dark Theme
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Força o Dark Theme no sistema (status bar, navigation bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Ícones claros na status bar
      systemNavigationBarColor: Color(0xFF121212), // Barra de navegação escura
      systemNavigationBarIconBrightness: Brightness.light, // Ícones claros na nav bar
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

      // Define apenas o Dark Theme como tema padrão
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme, // Remove o lightTheme - usa apenas dark

      initialRoute: AppRoutesManager.splash,
      onGenerateRoute: AppRoutesManager.generateRoute,

      // Configurações adicionais para melhor experiência no dark theme
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            platformBrightness: Brightness.dark, // Força dark em todos os dispositivos
          ),
          child: child!,
        );
      },
    );
  }
}
