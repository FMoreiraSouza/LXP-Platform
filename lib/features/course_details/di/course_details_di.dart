// lib/features/course_detail/di/course_detail_di.dart
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/di/dependency_manager.dart';
import 'package:lxp_platform/core/di/page_dependency.dart';
import 'package:lxp_platform/data/repository/implementation/course_repository.dart';
import 'package:lxp_platform/features/course_details/controllers/course_details_controller.dart';
import 'package:lxp_platform/features/course_details/usecases/get_course_details_usecase.dart';
import 'package:lxp_platform/features/course_details/ui/pages/course_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailsDI implements PageDependency {
  final String courseId;

  CourseDetailsDI({required this.courseId});

  @override
  void init() {
    final repository = DependencyManager.get<CourseRepository>();
    final sharedPreferences = DependencyManager.get<SharedPreferences>();

    final getCourseDetailsUseCase = GetCourseDetailsUseCase(repository: repository);

    DependencyManager.registerSingleton(getCourseDetailsUseCase);
    DependencyManager.registerSingleton(
      CourseDetailsController(
        getCourseDetailsUseCase: getCourseDetailsUseCase,
        sharedPreferences: sharedPreferences,
        courseId: courseId,
      ),
    );
  }

  @override
  StatefulWidget getPage() {
    return CourseDetailsPage(controller: DependencyManager.get<CourseDetailsController>());
  }
}
