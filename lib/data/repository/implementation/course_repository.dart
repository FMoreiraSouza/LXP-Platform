import 'package:lxp_platform/core/network/result_data.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/datasource/i_course_datasource.dart';
import 'package:lxp_platform/data/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/models/course_details_model.dart';
import 'package:lxp_platform/data/models/course_model.dart';
import 'package:lxp_platform/data/repository/i_course_repository.dart';

class CourseRepository implements ICourseRepository {
  final ICourseDataSource dataSource;

  CourseRepository({required this.dataSource});

  @override
  Future<ResultData<Failure, List<CourseModel>>> getCoursesByCategory(
    GetCoursesRequestDTO params,
  ) async {
    try {
      final coursesDTO = await dataSource.getCoursesByCategory(params);
      final courses = coursesDTO.map((dto) => CourseModel.fromDTO(dto, params.category)).toList();
      return ResultData.success(courses);
    } on Failure catch (e) {
      return ResultData.error(e);
    }
  }

  @override
  Future<ResultData<Failure, CourseDetailsModel>> getCourseDetails(String courseId) async {
    try {
      final courseDetailsDTO = await dataSource.getCourseDetails(courseId);
      final courseDetails = CourseDetailsModel.fromDTO(courseDetailsDTO);
      return ResultData.success(courseDetails);
    } on Failure catch (e) {
      return ResultData.error(e);
    }
  }
}
