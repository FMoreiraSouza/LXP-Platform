import 'package:flutter/material.dart';
import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/core/utils/enums/flow_state.dart';
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
  FlowState? _errorState;

  CourseDetailsModel? get courseDetails => _courseDetails;
  bool get isLoading => _isLoading;
  bool get isFavorite => _isFavorite;
  FlowState? get errorState => _errorState;

  CourseDetailsController({
    required this.getCourseDetailsUseCase,
    required this.sharedPreferences,
    required this.courseId,
  });

  Future<void> loadCourseDetails() async {
    _isLoading = true;
    _errorState = null;
    notifyListeners();

    final result = await getCourseDetailsUseCase.call(courseId);
    result.process(
      onError: (error) {
        _errorState = error is ConnectionException ? FlowState.noConnection : FlowState.error;
      },
      onSuccess: (course) {
        _errorState = null;
        _courseDetails = course;
        loadFavoriteStatus();
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFavoriteStatus() async {
    _isFavorite = await _isCourseFavorite();
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final favorites = sharedPreferences.getStringList(_favoriteCoursesKey)?.toSet().toList() ?? [];
    if (favorites.contains(courseId)) {
      favorites.remove(courseId);
    } else {
      favorites.add(courseId);
    }
    await sharedPreferences.setStringList(_favoriteCoursesKey, favorites);
    await loadFavoriteStatus();
  }

  Future<bool> _isCourseFavorite() async {
    final favorites = sharedPreferences.getStringList(_favoriteCoursesKey) ?? [];
    return favorites.contains(courseId);
  }
}
