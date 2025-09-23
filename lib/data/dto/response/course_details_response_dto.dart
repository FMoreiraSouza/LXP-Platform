class CourseDetailsResponseDTO {
  final String id;
  final String title; // FALTANDO
  final String? subtitle;
  final String? banner;
  final String? summary;
  final String? objective;

  CourseDetailsResponseDTO({
    required this.id,
    required this.title, // ADICIONAR
    this.subtitle,
    this.banner,
    this.summary,
    this.objective,
  });

  factory CourseDetailsResponseDTO.fromMap(Map<String, dynamic> map) {
    return CourseDetailsResponseDTO(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Sem título', // ADICIONAR
      subtitle: map['subtitle']?.toString(),
      banner: map['banner']?.toString(),
      summary: map['resume']?.toString(),
      objective: map['goal']?.toString(),
    );
  }
}
