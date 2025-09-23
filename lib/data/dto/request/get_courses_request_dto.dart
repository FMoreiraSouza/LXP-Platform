class GetCoursesRequestDTO {
  final String category;

  GetCoursesRequestDTO({required this.category});

  Map<String, dynamic> toMap() {
    return {'c': category};
  }
}
