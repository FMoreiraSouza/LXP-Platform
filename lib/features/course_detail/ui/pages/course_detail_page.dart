// lib/features/course_detail/ui/pages/course_detail_page.dart
import 'package:flutter/material.dart';
import 'package:lxp_platform/features/course_detail/controllers/course_detail_controller.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseDetailController controller;

  const CourseDetailPage({super.key, required this.controller});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadCourseDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Curso')),
      body: Center(child: Text('Detalhes do curso: ${widget.controller.courseId}')),
    );
  }
}
