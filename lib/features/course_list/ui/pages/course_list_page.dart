import 'package:flutter/material.dart';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

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
