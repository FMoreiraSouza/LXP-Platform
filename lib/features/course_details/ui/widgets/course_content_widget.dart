import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lxp_platform/data/models/course_details_model.dart';
import 'package:lxp_platform/features/course_details/controllers/course_details_controller.dart';
import 'package:lxp_platform/features/course_list/controllers/course_list_controller.dart';

class CourseContentWidget extends StatelessWidget {
  final CourseDetailsModel courseDetails;
  final CourseDetailsController controller;
  final CourseListController courseListController;

  const CourseContentWidget({
    super.key,
    required this.courseDetails,
    required this.controller,
    required this.courseListController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho com botão de voltar e banner
        Container(
          height: MediaQuery.of(context).padding.top + 60,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              _buildBannerBackground(),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
              if (_hasNoBanner())
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Text(
                    courseDetails.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0)),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        // Conteúdo principal
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (courseDetails.subtitle?.isNotEmpty == true) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        courseDetails.subtitle!,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(color: Colors.grey[300]),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          controller.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: controller.isFavorite ? Colors.red : Colors.white,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          await controller.toggleFavorite();
                          courseListController.updateFavoriteCourses();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              if (courseDetails.summary?.isNotEmpty == true) ...[
                Text(
                  'Resumo do Curso',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  courseDetails.summary!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[300],
                    height: 1.5,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 24),
              ],
              if (courseDetails.objective?.isNotEmpty == true) ...[
                Text(
                  'Objetivo',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  courseDetails.objective!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[300],
                    height: 1.5,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerBackground() {
    if (courseDetails.banner != null && courseDetails.banner!.isNotEmpty) {
      return ClipRRect(
        child: CachedNetworkImage(
          imageUrl: courseDetails.banner!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildPlaceholder(isLoading: true),
          errorWidget: (context, url, error) => _buildPlaceholder(isLoading: false),
        ),
      );
    }
    return _buildPlaceholder(isLoading: false);
  }

  Widget _buildPlaceholder({required bool isLoading}) {
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[900],
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
            strokeWidth: 3,
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF4A90E2).withOpacity(0.8), const Color(0xFF121212)],
        ),
      ),
      child: const Center(child: Icon(Icons.school, size: 80, color: Colors.white)),
    );
  }

  bool _hasNoBanner() {
    return courseDetails.banner == null || courseDetails.banner!.isEmpty;
  }
}
