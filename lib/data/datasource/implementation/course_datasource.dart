import 'package:dio/dio.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/datasource/i_course_datasource.dart';
import 'package:lxp_platform/data/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/dto/response/course_details_response_dto.dart';
import 'package:lxp_platform/data/dto/response/course_response_dto.dart';

class CourseDataSource implements ICourseDataSource {
  final Dio dio;

  CourseDataSource({required this.dio});

  @override
  Future<List<CourseResponseDTO>> getCoursesByCategory(GetCoursesRequestDTO params) async {
    try {
      final response = await dio.get('/event', queryParameters: params.toMap());

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => CourseResponseDTO.fromMap(json)).toList();
        } else if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List<dynamic> coursesData = data['data'];
          return coursesData.map((json) => CourseResponseDTO.fromMap(json)).toList();
        }
        return [];
      } else {
        throw ServerException('Failed to load courses');
      }
    } on DioException catch (e) {
      throw Failure('Dio error: ${e.message}');
    }
  }

  @override
  Future<CourseDetailsResponseDTO> getCourseDetails(String courseId) async {
    try {
      final response = await dio.get('/event/$courseId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final Map<String, dynamic> courseData = responseData["data"] as Map<String, dynamic>;
        var data = CourseDetailsResponseDTO.fromMap(courseData);
        return data;
      } else {
        throw ServerException('Failed to load course details');
      }
    } on DioException catch (e) {
      throw Failure('Dio error: ${e.message}');
    }
  }
}
