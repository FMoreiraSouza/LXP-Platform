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

          if (controller.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar curso',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.loadCourseDetails,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
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
