import 'package:flutter/material.dart';
import 'package:lxp_platform/core/ui/states/flow_state_widget.dart';
import 'package:lxp_platform/core/utils/enums/flow_state.dart';
import 'package:lxp_platform/data/models/course_model.dart';
import 'package:lxp_platform/features/course_list/controllers/course_list_controller.dart';
import 'package:lxp_platform/features/course_list/ui/widgets/course_item_widget.dart';

class CourseListWidget extends StatefulWidget {
  final CourseListController controller;

  const CourseListWidget({super.key, required this.controller});

  @override
  State<CourseListWidget> createState() => _CourseListWidgetState();
}

class _CourseListWidgetState extends State<CourseListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCategorySection(title: 'Cursos Fiscais', courses: widget.controller.fiscalCourses),
          const SizedBox(height: 24),
          _buildCategorySection(title: 'Cursos Contábeis', courses: widget.controller.contabilCourses),
          const SizedBox(height: 24),
          _buildCategorySection(title: 'Cursos Trabalhistas', courses: widget.controller.trabalhistaCourses),
        ],
      ),
    );
  }

  Widget _buildCategorySection({required String title, required List<CourseModel> courses}) {
    if (courses.isEmpty) {
      return FlowStateWidget(
        title: 'Nenhum curso em $title',
        description: 'Não há cursos disponíveis nesta categoria no momento.',
        hideButton: true,
        flowState: FlowState.empty,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseItemWidget(
                course: course,
                onCourseTap: (courseId) {
                  Navigator.of(context).pushNamed('/course-detail', arguments: courseId);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}