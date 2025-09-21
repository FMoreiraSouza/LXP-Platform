import 'package:flutter/material.dart';
import 'package:lxp_platform/core/network/api_service.dart';
import 'package:lxp_platform/data/course/models/course_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseListController extends ChangeNotifier {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;

  static const String _favoriteCoursesKey = 'favorite_courses';

  CourseListController({required this.apiService, required this.sharedPreferences});

  final List<CourseModel> _fiscalCourses = [];
  final List<CourseModel> _contabilCourses = [];
  final List<CourseModel> _trabalhistaCourses = [];
  final List<CourseModel> _favoriteCourses = [];
  bool _isLoading = false;
  String? _error;

  List<CourseModel> get fiscalCourses => _fiscalCourses;
  List<CourseModel> get contabilCourses => _contabilCourses;
  List<CourseModel> get trabalhistaCourses => _trabalhistaCourses;
  List<CourseModel> get favoriteCourses => _favoriteCourses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAllCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadCategoryCourses('fiscal', _fiscalCourses),
        _loadCategoryCourses('contabil', _contabilCourses),
        _loadCategoryCourses('trabalhista', _trabalhistaCourses),
        _loadFavoriteCourses(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCategoryCourses(String category, List<CourseModel> targetList) async {
    try {
      final response = await apiService.dio.get('/event?c=$category');

      if (response.statusCode == 200) {
        final data = response.data;
        targetList.clear();

        if (data is List) {
          targetList.addAll(data.map((json) => CourseModel.fromJson(json, category)));
        } else if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List<dynamic> coursesData = data['data'];
          targetList.addAll(coursesData.map((json) => CourseModel.fromJson(json, category)));
        }
      } else {
        throw Exception('Failed to load $category courses');
      }
    } catch (e) {
      throw Exception('Error loading $category courses: $e');
    }
  }

  Future<void> _loadFavoriteCourses() async {
    try {
      final favoriteIds = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];
      _favoriteCourses.clear();

      // Busca cursos favoritos em todas as categorias
      final allCourses = [..._fiscalCourses, ..._contabilCourses, ..._trabalhistaCourses];

      for (var id in favoriteIds) {
        final course = allCourses.firstWhere(
          (course) => course.id == id,
          orElse: () => CourseModel(id: '', title: '', category: ''),
        );
        if (course.id.isNotEmpty) {
          _favoriteCourses.add(course);
        }
      }
    } catch (e) {
      throw Exception('Error loading favorite courses: $e');
    }
  }

  Future<void> toggleFavorite(String courseId) async {
    final favorites = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];

    if (favorites.contains(courseId)) {
      favorites.remove(courseId);
    } else {
      favorites.add(courseId);
    }

    await sharedPreferences.setStringList(_favoriteCoursesKey, favorites);
    await _loadFavoriteCourses(); // Recarrega a lista de favoritos
    notifyListeners();
  }

  Future<bool> isFavorite(String courseId) async {
    final favorites = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];
    return favorites.contains(courseId);
  }
}
