import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseId;

  const CourseDetailPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Curso')),
      body: Center(child: Text('Detalhes do curso: $courseId')),
    );
  }
}
