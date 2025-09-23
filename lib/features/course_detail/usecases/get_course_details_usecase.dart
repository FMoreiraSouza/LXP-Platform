// lib/features/course_detail/usecases/get_course_details_usecase.dart
import 'package:lxp_platform/core/network/usecase.dart';
import 'package:lxp_platform/core/network/result_data.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/models/course_model.dart';
import 'package:lxp_platform/data/repository/i_course_repository.dart';

class GetCourseDetailsUseCase implements Usecase<CourseModel, String> {
  final ICourseRepository repository;

  GetCourseDetailsUseCase({required this.repository});

  @override
  Future<ResultData<Failure, CourseModel>> call(String courseId) async {
    return await repository.getCourseDetails(courseId);
  }
}
