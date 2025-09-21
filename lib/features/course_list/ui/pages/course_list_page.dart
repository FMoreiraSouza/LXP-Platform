// lib/features/course_list/ui/pages/course_list_page.dart
import 'package:flutter/material.dart';
import 'package:lxp_platform/features/course_list/controllers/course_list_controller.dart';

class CourseListPage extends StatefulWidget {
  final CourseListController controller;

  const CourseListPage({super.key, required this.controller});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadAllCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cursos Disponíveis')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/course-detail', arguments: 'curso-exemplo-123');
          },
          child: const Text('Ver Detalhes do Curso'),
        ),
      ),
    );
  }
}
