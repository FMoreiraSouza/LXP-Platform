// lib/features/course_detail/di/course_detail_di.dart
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/di/dependency_manager.dart';
import 'package:lxp_platform/core/di/page_dependency.dart';
import 'package:lxp_platform/data/repository/implementation/course_repository.dart';
import 'package:lxp_platform/features/course_detail/controllers/course_detail_controller.dart';
import 'package:lxp_platform/features/course_detail/usecases/get_course_details_usecase.dart';
import 'package:lxp_platform/features/course_detail/ui/pages/course_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailDI implements PageDependency {
  final String courseId;

  CourseDetailDI({required this.courseId});

  @override
  void init() {
    final repository = DependencyManager.get<CourseRepository>();
    final sharedPreferences = DependencyManager.get<SharedPreferences>();

    final getCourseDetailsUseCase = GetCourseDetailsUseCase(repository: repository);

    DependencyManager.registerSingleton(getCourseDetailsUseCase);
    DependencyManager.registerSingleton(
      CourseDetailController(
        getCourseDetailsUseCase: getCourseDetailsUseCase,
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
