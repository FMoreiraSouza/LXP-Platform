// lib/features/course_list/di/course_list_di.dart
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/di/dependency_manager.dart';
import 'package:lxp_platform/core/di/page_dependency.dart';
import 'package:lxp_platform/data/repository/implementation/course_repository.dart';
import 'package:lxp_platform/features/course_list/controllers/course_list_controller.dart';
import 'package:lxp_platform/features/course_list/usecases/get_courses_by_category_usecase.dart';
import 'package:lxp_platform/features/course_list/ui/pages/course_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseListDI implements PageDependency {
  @override
  void init() {
    // Use as dependências já registradas no GetIt
    final getCoursesUseCase = GetCoursesByCategoryUseCase(
      repository: DependencyManager.get<CourseRepository>(),
    );

    final sharedPreferences = DependencyManager.get<SharedPreferences>();

    DependencyManager.registerSingleton(
      CourseListController(
        getCoursesByCategoryUseCase: getCoursesUseCase,
        sharedPreferences: sharedPreferences,
      ),
    );
  }

  @override
  StatefulWidget getPage() {
    return CourseListPage(controller: DependencyManager.get<CourseListController>());
  }
}
