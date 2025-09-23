import 'package:lxp_platform/data/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/dto/response/course_response_dto.dart';

abstract class ICourseDataSource {
  Future<List<CourseResponseDTO>> getCoursesByCategory(GetCoursesRequestDTO params);
  Future<CourseResponseDTO> getCourseDetails(String courseId);
}
