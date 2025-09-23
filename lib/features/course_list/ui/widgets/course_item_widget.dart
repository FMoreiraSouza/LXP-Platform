import 'package:flutter/material.dart';
import 'package:lxp_platform/data/models/course_model.dart';

class CourseItemWidget extends StatelessWidget {
  final CourseModel course;
  final Function(String) onCourseTap;

  const CourseItemWidget({super.key, required this.course, required this.onCourseTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onCourseTap(course.id),
          child: Stack(
            children: [
              if (course.banner != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    course.banner!,
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 40),
                      );
                    },
                  ),
                )
              else
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school, size: 40, color: Colors.blue),
                ),
              if (course.banner != null)
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                    ),
                  ),
                ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  course.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
