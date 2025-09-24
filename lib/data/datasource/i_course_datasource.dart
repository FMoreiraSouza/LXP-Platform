import 'package:lxp_platform/data/dto/request/get_course_details_request_dto.dart';
import 'package:lxp_platform/data/dto/request/get_course_list_request_dto.dart';
import 'package:lxp_platform/data/dto/response/course_details_response_dto.dart';
import 'package:lxp_platform/data/dto/response/course_response_dto.dart';

abstract class ICourseDataSource {
  Future<List<CourseResponseDTO>> getCoursesByCategory(GetCourseListRequestDTO params);
  Future<CourseDetailsResponseDTO> getCourseDetails(GetCourseDetailsRequestDTO courseId);
}
