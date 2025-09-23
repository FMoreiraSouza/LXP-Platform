// lib/features/course_detail/ui/pages/course_detail_page.dart
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/ui/states/app_load_widget.dart';
import 'package:lxp_platform/data/models/course_model.dart';
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
      backgroundColor: const Color(0xFF121212),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          if (widget.controller.isLoading) {
            return const AppLoadWidget(label: 'Carregando curso...');
          }

          if (widget.controller.error != null) {
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
                      widget.controller.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => widget.controller.loadCourseDetails(),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final course = widget.controller.course;
          if (course == null) {
            return const Center(child: Text('Curso não encontrado'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(background: _buildBanner(course)),
                actions: [
                  IconButton(
                    icon: Icon(
                      widget.controller.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () => widget.controller.toggleFavorite(),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (course.subtitle?.isNotEmpty == true) ...[
                        Text(
                          course.subtitle!,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(color: Colors.grey[300]),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (course.summary?.isNotEmpty == true) ...[
                        Text(
                          'Resumo do Curso',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.summary!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[300], height: 1.5),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (course.objective?.isNotEmpty == true) ...[
                        Text(
                          'Objetivo',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.objective!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[300], height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBanner(CourseModel course) {
    if (course.banner != null && course.banner!.isNotEmpty) {
      return Image.network(
        course.banner!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderBanner();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingBanner();
        },
      );
    } else {
      return _buildPlaceholderBanner();
    }
  }

  Widget _buildPlaceholderBanner() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF4A90E2).withValues(alpha: 0.8), const Color(0xFF121212)],
        ),
      ),
      child: const Center(child: Icon(Icons.school, size: 80, color: Colors.white)),
    );
  }

  Widget _buildLoadingBanner() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
        ),
      ),
    );
  }
}
