import 'package:lxp_platform/data/course/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/course/dto/response/course_response_dto.dart';

abstract class ICourseDataSource {
  Future<List<CourseResponseDTO>> getCoursesByCategory(GetCoursesRequestDTO params);
  Future<CourseResponseDTO> getCourseDetails(String courseId);
}
