import 'package:flutter/material.dart';
import 'package:lxp_platform/core/constants/page_states.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/course/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/course/models/course_model.dart';
import 'package:lxp_platform/features/course_list/usecases/get_courses_by_category_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseListController extends ChangeNotifier {
  final GetCoursesByCategoryUseCase getCoursesByCategoryUseCase;
  final SharedPreferences sharedPreferences;

  static const String _favoriteCoursesKey = 'favorite_courses';

  CourseListController({
    required this.getCoursesByCategoryUseCase,
    required this.sharedPreferences,
  });

  List<CourseModel> _fiscalCourses = [];
  List<CourseModel> _contabilCourses = [];
  List<CourseModel> _trabalhistaCourses = [];
  final List<CourseModel> _favoriteCourses = [];

  int _state = PageStates.loadingState;
  bool _isLoading = false;
  String? _error;

  List<CourseModel> get fiscalCourses => _fiscalCourses;
  List<CourseModel> get contabilCourses => _contabilCourses;
  List<CourseModel> get trabalhistaCourses => _trabalhistaCourses;
  List<CourseModel> get favoriteCourses => _favoriteCourses;
  int get state => _state;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void initPage() {
    loadAllCourses();
  }

  Future<void> loadAllCourses() async {
    _updateState(PageStates.loadingState);
    _setLoading(true);
    _error = null;

    try {
      await Future.wait([
        _loadCategoryCourses('fiscal'),
        _loadCategoryCourses('contabil'),
        _loadCategoryCourses('trabalhista'),
        _loadFavoriteCourses(),
      ]);

      // Verifica se há cursos
      final hasCourses =
          _fiscalCourses.isNotEmpty ||
          _contabilCourses.isNotEmpty ||
          _trabalhistaCourses.isNotEmpty;

      if (hasCourses) {
        _updateState(PageStates.successState);
      } else {
        _updateState(PageStates.emptyState);
      }
    } on Failure catch (e) {
      _error = e.message;
      if (e is ConnectionException) {
        _updateState(PageStates.noConnection);
      } else {
        _updateState(PageStates.errorState);
      }
    } catch (e) {
      _error = e.toString();
      _updateState(PageStates.errorState);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadCategoryCourses(String category) async {
    final result = await getCoursesByCategoryUseCase.call(GetCoursesRequestDTO(category: category));

    result.process(
      onError: (error) => throw error,
      onSuccess: (courses) {
        switch (category) {
          case 'fiscal':
            _fiscalCourses = courses;
            break;
          case 'contabil':
            _contabilCourses = courses;
            break;
          case 'trabalhista':
            _trabalhistaCourses = courses;
            break;
        }
      },
    );
  }

  Future<void> _loadFavoriteCourses() async {
    try {
      final favoriteIds = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];
      _favoriteCourses.clear();

      final allCourses = [..._fiscalCourses, ..._contabilCourses, ..._trabalhistaCourses];

      for (var id in favoriteIds) {
        final course = allCourses.firstWhere(
          (course) => course.id == id,
          orElse: () => CourseModel.empty(),
        );
        if (course.id.isNotEmpty) {
          _favoriteCourses.add(course);
        }
      }
    } catch (e) {
      throw Failure('Error loading favorite courses: $e');
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
    await _loadFavoriteCourses();
    notifyListeners();
  }

  Future<bool> isFavorite(String courseId) async {
    final favorites = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];
    return favorites.contains(courseId);
  }

  void _updateState(int newState) {
    _state = newState;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void disposeControllers() {
    // Dispose de qualquer controlador se necessário
    super.dispose();
  }
}
