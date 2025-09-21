import 'package:flutter/material.dart';
import 'package:lxp_platform/core/di/dependency_manager.dart';
import 'package:lxp_platform/core/di/page_dependency.dart';
import 'package:lxp_platform/core/network/api_service.dart';
import 'package:lxp_platform/features/course_list/controllers/course_list_controller.dart';
import 'package:lxp_platform/features/course_list/ui/pages/course_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseListDI implements PageDependency {
  @override
  void init() {
    final apiService = DependencyManager.get<ApiService>();
    final sharedPreferences = DependencyManager.get<SharedPreferences>();

    DependencyManager.registerSingleton(
      CourseListController(apiService: apiService, sharedPreferences: sharedPreferences),
    );
  }

  @override
  StatefulWidget getPage() {
    return CourseListPage(controller: DependencyManager.get<CourseListController>());
  }
}
