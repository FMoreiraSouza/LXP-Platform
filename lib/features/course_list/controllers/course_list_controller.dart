import 'package:flutter/material.dart';
import 'package:lxp_platform/core/constants/page_states.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/data/dto/request/get_course_list_request_dto.dart';
import 'package:lxp_platform/data/models/course_model.dart';
import 'package:lxp_platform/features/course_list/usecases/get_course_list_by_category_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseListController extends ChangeNotifier {
  final GetCourseListByCategoryUseCase getCoursesByCategoryUseCase;
  final SharedPreferences sharedPreferences;

  CourseListController({
    required this.getCoursesByCategoryUseCase,
    required this.sharedPreferences,
  });

  List<CourseModel> _taxCourseList = [];
  List<CourseModel> _accountingCourseList = [];
  List<CourseModel> _laborCourseList = [];
  List<CourseModel> _favoriteCourseList = [];

  int _state = PageStates.loadingState;
  bool _isLoading = false;
  bool _hasLoaded = false;
  DateTime? _lastLoadTime;
  static const Duration _cacheDuration = Duration(minutes: 10);
  static const String _favoriteCoursesKey = 'favorite_courses';
  static const String _lastLoadTimeKey = 'courses_last_load_time';

  List<CourseModel> get taxCourses => _taxCourseList;
  List<CourseModel> get accountingCourses => _accountingCourseList;
  List<CourseModel> get laborCourses => _laborCourseList;
  List<CourseModel> get favoriteCourses => _favoriteCourseList;
  int get state => _state;
  bool get isLoading => _isLoading;

  void initPage() {
    _loadLastLoadTime();
    _updateState(PageStates.loadingState);

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
    return now.difference(_lastLoadTime!) < _cacheDuration;
  }

  Future<void> loadAllCourses({bool refresh = false}) async {
    if (refresh) {
      _updateState(PageStates.loadingState);
      _hasLoaded = false;
      _lastLoadTime = null;
      _taxCourseList.clear();
      _accountingCourseList.clear();
      _laborCourseList.clear();
      _favoriteCourseList.clear();
    }
    if (_isLoading) return;

    _setLoading(true);
    notifyListeners();

    final categories = ['fiscal', 'contabil', 'trabalhista'];
    final results = await Future.wait(
      categories.map(
        (category) => getCoursesByCategoryUseCase.call(GetCourseListRequestDTO(category: category)),
      ),
    );

    bool hasError = false;
    for (var i = 0; i < results.length; i++) {
      results[i].process(
        onError: (error) {
          hasError = true;
          _checkErrorState(error);
        },
        onSuccess: (courseList) {
          switch (categories[i]) {
            case 'fiscal':
              _taxCourseList = courseList;
              break;
            case 'contabil':
              _accountingCourseList = courseList;
              break;
            case 'trabalhista':
              _laborCourseList = courseList;
              break;
          }
        },
      );
    }

    if (hasError) {
    } else if (_taxCourseList.isNotEmpty ||
        _accountingCourseList.isNotEmpty ||
        _laborCourseList.isNotEmpty) {
      _updateState(PageStates.successState);
      _hasLoaded = true;
      _lastLoadTime = DateTime.now();
      _saveLastLoadTime();
    } else {
      _updateState(PageStates.emptyState);
    }

    _loadFavoriteCourses();
    _setLoading(false);
    notifyListeners();
  }

  void _loadFavoriteCourses() {
    final favoriteIds = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];
    final allCourses = [..._taxCourseList, ..._accountingCourseList, ..._laborCourseList];

    final uniqueFavorites = <String>{};
    _favoriteCourseList = allCourses
        .where((course) => favoriteIds.contains(course.id) && uniqueFavorites.add(course.id))
        .toList();

    final uniqueFavoriteIds = favoriteIds.toSet().toList();
    sharedPreferences.setStringList(_favoriteCoursesKey, uniqueFavoriteIds);

    notifyListeners();
  }

  void updateFavoriteCourses() {
    _loadFavoriteCourses();
  }

  void _checkErrorState(dynamic error) {
    if (error is ConnectionException) {
      _updateState(PageStates.noConnection);
    } else {
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
    if (_lastLoadTime != null) {
      sharedPreferences.setString(
        _lastLoadTimeKey,
        _lastLoadTime!.millisecondsSinceEpoch.toString(),
      );
    }
  }

  void _loadLastLoadTime() {
    final timestamp = sharedPreferences.getString(_lastLoadTimeKey);
    if (timestamp != null) {
      _lastLoadTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      _hasLoaded =
          _taxCourseList.isNotEmpty ||
          _accountingCourseList.isNotEmpty ||
          _laborCourseList.isNotEmpty;
    }
  }

  Future<void> refreshCourses() async {
    _hasLoaded = false;
    _lastLoadTime = null;
    await loadAllCourses();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
