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

  int _state = PageStates.loadingState;
  bool _isLoading = false;
  String? _error;

  List<CourseModel> get fiscalCourses => _fiscalCourses;
  List<CourseModel> get contabilCourses => _contabilCourses;
  List<CourseModel> get trabalhistaCourses => _trabalhistaCourses;
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
      ]);

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
      _checkErrorState(e);
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

  void disposeControllers() {
    super.dispose();
  }
}
