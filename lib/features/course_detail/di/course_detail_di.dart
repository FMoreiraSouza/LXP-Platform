import 'package:flutter/material.dart';
import 'package:lxp_platform/core/di/dependency_manager.dart';
import 'package:lxp_platform/core/di/page_dependency.dart';
import 'package:lxp_platform/core/network/api_service.dart';
import 'package:lxp_platform/features/course_detail/controllers/course_detail_controller.dart';
import 'package:lxp_platform/features/course_detail/ui/pages/course_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailDI implements PageDependency {
  final String courseId;

  CourseDetailDI({required this.courseId});

  @override
  void init() {
    final apiService = DependencyManager.get<ApiService>();
    final sharedPreferences = DependencyManager.get<SharedPreferences>();

    DependencyManager.registerSingleton(
      CourseDetailController(
        apiService: apiService,
        sharedPreferences: sharedPreferences,
        courseId: courseId,
      ),
    );
  }

  @override
  StatefulWidget getPage() {
    return CourseDetailPage(controller: DependencyManager.get<CourseDetailController>());
  }
}
