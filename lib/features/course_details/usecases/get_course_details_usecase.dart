import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/core/network/result_data.dart';
import 'package:lxp_platform/core/network/usecase.dart';
import 'package:lxp_platform/data/dto/request/get_course_details_request_dto.dart';
import 'package:lxp_platform/data/models/course_details_model.dart';
import 'package:lxp_platform/data/repository/i_course_repository.dart';

class GetCourseDetailsUseCase implements Usecase<CourseDetailsModel, GetCourseDetailsRequestDTO> {
  final ICourseRepository repository;

  GetCourseDetailsUseCase({required this.repository});

  @override
  Future<ResultData<Failure, CourseDetailsModel>> call(GetCourseDetailsRequestDTO params) async {
    return await repository.getCourseDetails(params);
  }
}
