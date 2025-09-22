import 'package:flutter/material.dart';
import 'package:lxp_platform/core/network/api_service.dart';
import 'package:lxp_platform/data/course/models/course_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailController extends ChangeNotifier {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;
  final String courseId;

  static const String _favoriteCoursesKey = 'favorite_courses';

  CourseDetailController({
    required this.apiService,
    required this.sharedPreferences,
    required this.courseId,
  });

  CourseModel? _course;
  bool _isLoading = false;
  bool _isFavorite = false;
  String? _error;

  CourseModel? get course => _course;
  bool get isLoading => _isLoading;
  bool get isFavorite => _isFavorite;
  String? get error => _error;

  Future<void> loadCourseDetails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/event/$courseId');

      if (response.statusCode == 200) {
        final data = response.data;
        _course = data;

        // Verifica se é favorito
        _isFavorite = await _isCourseFavorite(courseId);
      } else {
        throw Exception('Failed to load course details');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    await _toggleFavoriteCourse(courseId);
    _isFavorite = await _isCourseFavorite(courseId);
    notifyListeners();
  }

  Future<bool> _isCourseFavorite(String courseId) async {
    final favorites = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];
    return favorites.contains(courseId);
  }

  Future<void> _toggleFavoriteCourse(String courseId) async {
    final favorites = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];

    if (favorites.contains(courseId)) {
      favorites.remove(courseId);
    } else {
      favorites.add(courseId);
    }

    await sharedPreferences.setStringList(_favoriteCoursesKey, favorites);
  }
}
