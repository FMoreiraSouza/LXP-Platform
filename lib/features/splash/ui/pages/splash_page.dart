import 'package:flutter/material.dart';
import 'package:lxp_platform/core/utils/responsivity_utils.dart';
import 'package:lxp_platform/gen/assets.gen.dart';
import 'package:lxp_platform/routes/app_routes_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

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
      Navigator.of(context).pushReplacementNamed(AppRoutesManager.courseList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsivity = ResponsivityUtils(context);
    return Scaffold(
      body: Center(
        child: Assets.images.logo.image(
          width: responsivity.imageSize(),
          height: responsivity.imageSize(),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
