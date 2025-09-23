class CourseResponseDTO {
  final String id;
  final String title;
  final String? banner;

  CourseResponseDTO({required this.id, required this.title, this.banner});

  factory CourseResponseDTO.fromMap(Map<String, dynamic> map) {
    return CourseResponseDTO(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Sem título',
      banner: map['banner']?.toString(),
    );
  }
}
