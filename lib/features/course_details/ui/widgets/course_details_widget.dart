import 'package:flutter/material.dart';
import 'package:lxp_platform/core/di/service_locator.dart';
import 'package:lxp_platform/core/ui/states/app_load_widget.dart';
import 'package:lxp_platform/features/course_details/controllers/course_details_controller.dart';
import 'package:lxp_platform/features/course_details/ui/widgets/course_content_widget.dart';
import 'package:lxp_platform/features/course_list/controllers/course_list_controller.dart';

class CourseDetailsWidget extends StatelessWidget {
  final CourseDetailsController controller;

  const CourseDetailsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final courseListController = sl<CourseListController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const AppLoadWidget(label: 'Carregando curso');
          }

          final courseDetails = controller.courseDetails;
          if (courseDetails == null) {
            return const Center(child: Text('Curso não encontrado'));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CourseContentWidget(
                  courseDetails: courseDetails,
                  controller: controller,
                  courseListController: courseListController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
