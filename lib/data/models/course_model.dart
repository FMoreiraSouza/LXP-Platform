import 'package:lxp_platform/data/dto/response/course_response_dto.dart';

class CourseModel {
  final String id;
  final String title;
  final String? banner;
  final String category;

  CourseModel({required this.id, required this.title, this.banner, required this.category});

  factory CourseModel.fromDTO(CourseResponseDTO dto, String category) {
    return CourseModel(id: dto.id, title: dto.title, banner: dto.banner, category: category);
  }
}
