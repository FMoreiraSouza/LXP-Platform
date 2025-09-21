// lib/core/models/course_model.dart
class CourseModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? banner;
  final String? summary;
  final String? objective;
  final String category;

  CourseModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.banner,
    this.summary,
    this.objective,
    required this.category,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json, String category) {
    return CourseModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Sem título',
      subtitle: json['subtitle']?.toString(),
      banner: json['banner']?.toString(),
      summary: json['summary']?.toString(),
      objective: json['objective']?.toString(),
      category: category,
    );
  }

  static CourseModel empty() {
    return CourseModel(id: '', title: '', category: '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CourseModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
