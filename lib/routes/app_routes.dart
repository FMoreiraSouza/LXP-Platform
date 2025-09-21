import 'package:flutter/material.dart';
import 'package:lxp_platform/features/course_detail/ui/pages/course_detail_page.dart';
import 'package:lxp_platform/features/course_list/ui/pages/course_list_page.dart';
import 'package:lxp_platform/features/splash/ui/pages/splash_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String courseList = '/course-list';
  static const String courseDetail = '/course-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case courseList:
        return MaterialPageRoute(builder: (_) => const CourseListPage());

      case courseDetail:
        final courseId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CourseDetailPage(courseId: courseId), // CORREÇÃO AQUI
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Rota ${settings.name} não encontrada'))),
        );
    }
  }
}
