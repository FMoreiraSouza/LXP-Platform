// lib/features/course_detail/controllers/course_detail_controller.dart
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/models/course_model.dart';
import 'package:lxp_platform/features/course_detail/usecases/get_course_details_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailController extends ChangeNotifier {
  final GetCourseDetailsUseCase getCourseDetailsUseCase;
  final SharedPreferences sharedPreferences;
  final String courseId;

  static const String _favoriteCoursesKey = 'favorite_courses';

  CourseDetailController({
    required this.getCourseDetailsUseCase,
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
      final result = await getCourseDetailsUseCase.call(courseId);

      result.process(
        onError: (error) => throw error,
        onSuccess: (course) {
          _course = course;
          _loadFavoriteStatus();
        },
      );
    } on Failure catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFavoriteStatus() async {
    _isFavorite = await _isCourseFavorite(courseId);
    notifyListeners();
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
