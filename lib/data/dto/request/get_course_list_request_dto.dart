class GetCourseListRequestDTO {
  final String category;

  GetCourseListRequestDTO({required this.category});

  Map<String, dynamic> toMap() {
    return {'c': category};
  }
}
