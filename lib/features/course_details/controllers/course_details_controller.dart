import 'package:flutter/material.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/models/course_details_model.dart';
import 'package:lxp_platform/features/course_details/usecases/get_course_details_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailsController extends ChangeNotifier {
  final GetCourseDetailsUseCase getCourseDetailsUseCase;
  final SharedPreferences sharedPreferences;
  final String courseId;

  static const String _favoriteCoursesKey = 'favorite_courses';

  CourseDetailsModel? _courseDetails;
  bool _isLoading = false;
  bool _isFavorite = false;
  String? _error;

  CourseDetailsModel? get courseDetails => _courseDetails;
  bool get isLoading => _isLoading;
  bool get isFavorite => _isFavorite;
  String? get error => _error;

  CourseDetailsController({
    required this.getCourseDetailsUseCase,
    required this.sharedPreferences,
    required this.courseId,
  });

  Future<void> loadCourseDetails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await getCourseDetailsUseCase.call(courseId);

      result.process(
        onError: (error) => throw error,
        onSuccess: (course) {
          _courseDetails = course;
          loadFavoriteStatus(); // Carrega o estado de favorito após carregar os detalhes
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

  Future<void> loadFavoriteStatus() async {
    _isFavorite = await _isCourseFavorite(courseId);
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final favorites = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];

    // Evita duplicatas: remove o ID se já existe, ou adiciona se não existe
    if (favorites.contains(courseId)) {
      favorites.remove(courseId);
    } else {
      if (!favorites.contains(courseId)) {
        // Verificação extra para segurança
        favorites.add(courseId);
      }
    }

    await sharedPreferences.setStringList(_favoriteCoursesKey, favorites);
    await loadFavoriteStatus(); // Recarrega o estado de favorito após a alteração
  }

  Future<bool> _isCourseFavorite(String courseId) async {
    final favorites = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];
    return favorites.contains(courseId);
  }
}
