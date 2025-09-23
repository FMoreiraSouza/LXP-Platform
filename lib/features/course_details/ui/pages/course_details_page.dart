// lib/features/course_detail/ui/pages/course_detail_page.dart
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/ui/states/app_load_widget.dart';
import 'package:lxp_platform/data/models/course_details_model.dart';
import 'package:lxp_platform/features/course_details/controllers/course_details_controller.dart';

class CourseDetailsPage extends StatefulWidget {
  final CourseDetailsController controller;

  const CourseDetailsPage({super.key, required this.controller});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
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
            return const AppLoadWidget(label: 'Carregando curso');
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

          final courseDetails = widget.controller.courseDetails;
          if (courseDetails == null) {
            return const Center(child: Text('Curso não encontrado'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(background: _buildBanner(courseDetails)),
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
                      // TÍTULO SEMPRE VISÍVEL (igual ao CourseListWidget)
                      Text(
                        courseDetails.title,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (courseDetails.subtitle?.isNotEmpty == true) ...[
                        Text(
                          courseDetails.subtitle!,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(color: Colors.grey[300]),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (courseDetails.summary?.isNotEmpty == true) ...[
                        Text(
                          'Resumo do Curso',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          courseDetails.summary!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[300], height: 1.5),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (courseDetails.objective?.isNotEmpty == true) ...[
                        Text(
                          'Objetivo',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          courseDetails.objective!,
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

  Widget _buildBanner(CourseDetailsModel course) {
    if (course.banner != null && course.banner!.isNotEmpty) {
      return Image.network(
        course.banner!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderBanner(course); // Passar o curso para mostrar título
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingBanner();
        },
      );
    } else {
      return _buildPlaceholderBanner(course); // Passar o curso para mostrar título
    }
  }

  Widget _buildPlaceholderBanner(CourseDetailsModel course) {
    return Stack(
      children: [
        Container(
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
        ),
        // TÍTULO SOBREPOSTO NO PLACEHOLDER (igual ao CourseItemWidget)
        if (course.banner == null || course.banner!.isEmpty)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Text(
              course.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0))],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
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
