import 'package:flutter/material.dart';
import 'package:lxp_platform/core/constants/page_states.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/dto/request/get_courses_request_dto.dart';
import 'package:lxp_platform/data/models/course_model.dart';
import 'package:lxp_platform/features/course_list/usecases/get_courses_by_category_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseListController extends ChangeNotifier {
  final GetCoursesByCategoryUseCase getCoursesByCategoryUseCase;
  final SharedPreferences sharedPreferences;

  CourseListController({
    required this.getCoursesByCategoryUseCase,
    required this.sharedPreferences,
  });

  List<CourseModel> _fiscalCourses = [];
  List<CourseModel> _contabilCourses = [];
  List<CourseModel> _trabalhistaCourses = [];
  List<CourseModel> _favoriteCourses = [];

  int _state = PageStates.loadingState;
  bool _isLoading = false;
  String? _error;

  bool _hasLoaded = false;
  DateTime? _lastLoadTime;
  static const Duration _cacheDuration = Duration(minutes: 10);

  static const String _favoriteCoursesKey = 'favorite_courses';
  static const String _lastLoadTimeKey = 'courses_last_load_time';

  List<CourseModel> get fiscalCourses => _fiscalCourses;
  List<CourseModel> get contabilCourses => _contabilCourses;
  List<CourseModel> get trabalhistaCourses => _trabalhistaCourses;
  List<CourseModel> get favoriteCourses => _favoriteCourses;
  int get state => _state;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void initPage() {
    _loadLastLoadTime();

    // Forçar recarregamento se as listas estão vazias (ex.: após hot restart)
    if (_fiscalCourses.isEmpty && _contabilCourses.isEmpty && _trabalhistaCourses.isEmpty) {
      _hasLoaded = false;
    }

    // Sempre definir o estado inicial como loading antes de verificar o cache
    _updateState(PageStates.loadingState);
    notifyListeners(); // Garantir que a UI reflita o estado de loading

    if (_hasLoaded && _shouldUseCache()) {
      _updateState(PageStates.successState);
      _loadFavoriteCourses();
      return;
    }

    loadAllCourses();
  }

  bool _shouldUseCache() {
    if (_lastLoadTime == null) return false;

    final now = DateTime.now();
    final difference = now.difference(_lastLoadTime!);
    return difference < _cacheDuration;
  }

  Future<void> loadAllCourses() async {
    if (_isLoading) return;

    _updateState(PageStates.loadingState); // Reforçar o estado de loading
    _setLoading(true);
    _error = null;
    notifyListeners(); // Garantir que a UI mostre o AppLoadWidget

    try {
      await Future.wait([
        _loadCategoryCourses('fiscal'),
        _loadCategoryCourses('contabil'),
        _loadCategoryCourses('trabalhista'),
      ]);

      final hasCourses =
          _fiscalCourses.isNotEmpty ||
          _contabilCourses.isNotEmpty ||
          _trabalhistaCourses.isNotEmpty;

      if (hasCourses) {
        _updateState(PageStates.successState);
        _hasLoaded = true;
        _lastLoadTime = DateTime.now();
        _saveLastLoadTime();
      } else {
        _updateState(PageStates.emptyState);
      }

      _loadFavoriteCourses();
    } on Failure catch (e) {
      _error = e.message;
      _checkErrorState(e);
    } catch (e) {
      _error = e.toString();
      _updateState(PageStates.errorState);
    } finally {
      _setLoading(false);
      notifyListeners(); // Garantir que a UI seja atualizada após o carregamento
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

  void _loadFavoriteCourses() {
    final favoriteIds = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];
    final allCourses = [..._fiscalCourses, ..._contabilCourses, ..._trabalhistaCourses];

    // Remove duplicatas usando um Set para IDs únicos
    final uniqueFavorites = <String>{};
    _favoriteCourses = allCourses
        .where((course) => favoriteIds.contains(course.id) && uniqueFavorites.add(course.id))
        .toList();

    // Limpa duplicatas no SharedPreferences
    final uniqueFavoriteIds = favoriteIds.toSet().toList();
    sharedPreferences.setStringList(_favoriteCoursesKey, uniqueFavoriteIds);

    notifyListeners();
  }

  void updateFavoriteCourses() {
    _loadFavoriteCourses();
    notifyListeners();
  }

  void _checkErrorState(Failure failure) {
    switch (failure.runtimeType) {
      case ConnectionException:
        _updateState(PageStates.noConnection);
        break;
      default:
        _updateState(PageStates.errorState);
    }
  }

  void _updateState(int newState) {
    _state = newState;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _saveLastLoadTime() {
    final timestamp = _lastLoadTime?.millisecondsSinceEpoch.toString();
    if (timestamp != null) {
      sharedPreferences.setString(_lastLoadTimeKey, timestamp);
    }
  }

  void _loadLastLoadTime() {
    final timestamp = sharedPreferences.getString(_lastLoadTimeKey);
    if (timestamp != null) {
      _lastLoadTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      // Só considerar _hasLoaded como true se as listas não estiverem vazias
      if (_fiscalCourses.isNotEmpty ||
          _contabilCourses.isNotEmpty ||
          _trabalhistaCourses.isNotEmpty) {
        _hasLoaded = true;
      } else {
        _hasLoaded = false; // Forçar recarregamento se listas estão vazias
      }
    }
  }

  Future<void> refreshCourses() async {
    _hasLoaded = false;
    _lastLoadTime = null;
    await loadAllCourses();
  }

  void disposeControllers() {
    super.dispose();
  }
}
