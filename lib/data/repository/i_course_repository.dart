import 'package:lxp_platform/core/network/result_data.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/models/course_details_model.dart';
import 'package:lxp_platform/data/models/course_model.dart';

abstract class ICourseRepository {
  Future<ResultData<Failure, List<CourseModel>>> getCoursesByCategory(GetCoursesRequestDTO params);
  Future<ResultData<Failure, CourseDetailsModel>> getCourseDetails(String courseId);
}
