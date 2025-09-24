import 'package:lxp_platform/data/dto/response/course_details_response_dto.dart';

class CourseDetailsModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? banner;
  final String? summary;
  final String? objective;

  CourseDetailsModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.banner,
    this.summary,
    this.objective,
  });

  factory CourseDetailsModel.fromDTO(CourseDetailsResponseDTO dto) {
    return CourseDetailsModel(
      id: dto.id,
      title: dto.title,
      subtitle: dto.subtitle,
      banner: dto.banner,
      summary: dto.summary,
      objective: dto.objective,
    );
  }
}
