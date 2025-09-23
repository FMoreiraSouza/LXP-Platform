class CourseResponseDTO {
  final String id;
  final String title;
  final String? subtitle;
  final String? banner;
  final String? summary;
  final String? objective;

  CourseResponseDTO({
    required this.id,
    required this.title,
    this.subtitle,
    this.banner,
    this.summary,
    this.objective,
  });

  factory CourseResponseDTO.fromMap(Map<String, dynamic> map) {
    return CourseResponseDTO(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Sem título',
      subtitle: map['subtitle']?.toString(),
      banner: map['banner']?.toString(),
      summary: map['summary']?.toString(),
      objective: map['objective']?.toString(),
    );
  }
}
