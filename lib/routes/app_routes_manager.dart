import 'package:flutter/material.dart';
import 'package:lxp_platform/features/course_details/di/course_details_di.dart';
import 'package:lxp_platform/features/course_list/di/course_list_di.dart';
import 'package:lxp_platform/features/splash/di/splash_di.dart';

class AppRoutesManager {
  static const String splash = '/';
  static const String courseList = '/course-list';
  static const String courseDetails = '/course-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        final di = SplashDI();
        di.init();
        return MaterialPageRoute(builder: (_) => di.getPage());

      case courseList:
        final di = CourseListDI();
        di.init();
        return MaterialPageRoute(builder: (_) => di.getPage());

      case courseDetails:
        final courseId = settings.arguments as String;
        final di = CourseDetailsDI(courseId: courseId);
        di.init();
        return MaterialPageRoute(builder: (_) => di.getPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Rota ${settings.name} não encontrada'))),
        );
    }
  }
}
