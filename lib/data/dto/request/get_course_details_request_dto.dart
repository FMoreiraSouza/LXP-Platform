class GetCourseDetailsRequestDTO {
  final String courseId;

  GetCourseDetailsRequestDTO({required this.courseId});

  Map<String, dynamic> toMap() {
    return {'id': courseId};
  }
}
