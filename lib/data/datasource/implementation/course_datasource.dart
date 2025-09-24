import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:lxp_platform/core/network/base_connection_service.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/datasource/i_course_datasource.dart';
import 'package:lxp_platform/data/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/dto/response/course_details_response_dto.dart';
import 'package:lxp_platform/data/dto/response/course_response_dto.dart';

class CourseDataSource extends BaseConnectionService implements ICourseDataSource {
  final Dio dio;

  CourseDataSource({required this.dio, required Connectivity connectivity})
    : super(connectivity: connectivity);

  @override
  Future<List<CourseResponseDTO>> getCoursesByCategory(GetCoursesRequestDTO params) async {
    await isConnected(); // Verifica a conectividade antes da requisição

    try {
      final response = await dio.get('/event', queryParameters: params.toMap());

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List<dynamic> coursesData = data['data'];
          if (coursesData.isEmpty) {
            return [];
          }
          return coursesData.map((json) => CourseResponseDTO.fromMap(json)).toList();
        } else {
          throw ServerException('Erro ao carregar cursos');
        }
      } else {
        throw ServerException('Erro ao carregar cursos');
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionException('Falha na conexão com o servidor.');
      }
      rethrow;
    }
  }

  @override
  Future<CourseDetailsResponseDTO> getCourseDetails(String courseId) async {
    await isConnected(); // Verifica a conectividade antes da requisição

    try {
      final response = await dio.get('/event/$courseId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final Map<String, dynamic> courseData = responseData["data"] as Map<String, dynamic>;
        return CourseDetailsResponseDTO.fromMap(courseData);
      } else {
        throw ServerException('Failed to load course details');
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionException('Falha na conexão com o servidor.');
      }
      rethrow;
    }
  }
}
