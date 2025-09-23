import 'package:lxp_platform/core/network/usecase.dart';
import 'package:lxp_platform/core/network/result_data.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/models/course_model.dart';
import 'package:lxp_platform/data/repository/i_course_repository.dart';

class GetCoursesByCategoryUseCase implements Usecase<List<CourseModel>, GetCoursesRequestDTO> {
  final ICourseRepository repository;

  GetCoursesByCategoryUseCase({required this.repository});

  @override
  Future<ResultData<Failure, List<CourseModel>>> call(GetCoursesRequestDTO params) async {
    return await repository.getCoursesByCategory(params);
  }
}
