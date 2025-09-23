// Atualize o CourseListWidget existente
import 'package:flutter/material.dart';
import 'package:lxp_platform/data/models/course_model.dart';
import 'package:lxp_platform/features/course_list/controllers/course_list_controller.dart';
import 'package:lxp_platform/features/course_list/ui/widgets/course_item_widget.dart';
import 'package:lxp_platform/routes/app_routes_manager.dart';

class CourseListWidget extends StatefulWidget {
  final CourseListController controller;

  const CourseListWidget({super.key, required this.controller});

  @override
  State<CourseListWidget> createState() => _CourseListWidgetState();
}

class _CourseListWidgetState extends State<CourseListWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Explore Cursos',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Descubra conteúdos incríveis para sua formação',
            style: TextStyle(fontSize: 16, color: Colors.grey[400], fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 32),

          Expanded(
            child: ListView(
              children: [
                // Seção de Cursos Favoritos (apenas se houver favoritos)
                if (widget.controller.favoriteCourses.isNotEmpty) ...[
                  _buildCategorySection(
                    title: 'Seus Cursos Favoritos',
                    courses: widget.controller.favoriteCourses,
                    icon: Icons.favorite,
                    gradient: const [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
                    count: widget.controller.favoriteCourses.length,
                  ),
                  const SizedBox(height: 32),
                ],

                _buildCategorySection(
                  title: 'Fiscais',
                  courses: widget.controller.fiscalCourses,
                  icon: Icons.account_balance,
                  gradient: const [Color(0xFF4A90E2), Color(0xFF357ABD)],
                  count: widget.controller.fiscalCourses.length,
                ),
                const SizedBox(height: 32),
                _buildCategorySection(
                  title: 'Contábeis',
                  courses: widget.controller.contabilCourses,
                  icon: Icons.calculate,
                  gradient: const [Color(0xFF7B68EE), Color(0xFF5A4FCF)],
                  count: widget.controller.contabilCourses.length,
                ),
                const SizedBox(height: 32),
                _buildCategorySection(
                  title: 'Trabalhistas',
                  courses: widget.controller.trabalhistaCourses,
                  icon: Icons.work,
                  gradient: const [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
                  count: widget.controller.trabalhistaCourses.length,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required List<CourseModel> courses,
    required IconData icon,
    required List<Color> gradient,
    required int count,
  }) {
    if (courses.isEmpty) {
      return const SizedBox.shrink(); // Não mostra seção vazia
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient[1].withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Explore ${count > 1 ? '$count cursos' : '1 curso'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...courses.map((course) {
                return CourseItemWidget(
                  course: course,
                  onCourseTap: (courseId) {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutesManager.courseDetail, arguments: courseId);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
