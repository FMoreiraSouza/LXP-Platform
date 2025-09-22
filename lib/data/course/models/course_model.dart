import 'package:lxp_platform/data/course/dto/response/course_response_dto.dart';

class CourseModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? banner;
  final String? summary;
  final String? objective;
  final String category;

  CourseModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.banner,
    this.summary,
    this.objective,
    required this.category,
  });

  factory CourseModel.fromDTO(CourseResponseDTO dto, String category) {
    return CourseModel(
      id: dto.id,
      title: dto.title,
      subtitle: dto.subtitle,
      banner: dto.banner,
      summary: dto.summary,
      objective: dto.objective,
      category: category,
    );
  }

  static CourseModel empty() {
    return CourseModel(id: '', title: '', category: '');
  }
}
