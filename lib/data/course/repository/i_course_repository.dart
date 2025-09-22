import 'package:lxp_platform/core/network/result_data.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/course/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/course/models/course_model.dart';

abstract class ICourseRepository {
  Future<ResultData<Failure, List<CourseModel>>> getCoursesByCategory(GetCoursesRequestDTO params);
  Future<ResultData<Failure, CourseModel>> getCourseDetails(String courseId);
}
