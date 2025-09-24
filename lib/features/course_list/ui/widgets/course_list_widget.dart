import 'package:flutter/material.dart';
import 'package:lxp_platform/core/constants/responsivity_constants.dart';
import 'package:lxp_platform/core/utils/responsivity_utils.dart';
import 'package:lxp_platform/data/models/course_model.dart';
import 'package:lxp_platform/features/course_list/controllers/course_list_controller.dart';
import 'package:lxp_platform/features/course_list/ui/widgets/course_item_widget.dart';
import 'package:lxp_platform/routes/app_routes_manager.dart';

class CourseListWidget extends StatefulWidget {
  final CourseListController controller;

  const CourseListWidget({super.key, required this.controller});

  @override
  State<CourseListWidget> createState() => _CourseListWidgetState();
}

class _CourseListWidgetState extends State<CourseListWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final responsivity = ResponsivityUtils(context);
    return Padding(
      padding: responsivity.responsiveAllPadding(ResponsivityConstants.defaultSpacingPercentage),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Explore Cursos',
            style: TextStyle(
              fontSize: responsivity.extraLargeTextSize(),
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: responsivity.smallSpacing()),
          Text(
            'Descubra conteúdos incríveis para sua formação',
            style: TextStyle(
              fontSize: responsivity.mediumTextSize(),
              color: Colors.grey[400],
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: responsivity.largeSpacing()),
          Expanded(
            child: ListView(
              children: [
                if (widget.controller.favoriteCourses.isNotEmpty) ...[
                  _buildCategorySection(
                    title: 'Seus Cursos Favoritos',
                    courses: widget.controller.favoriteCourses,
                    icon: Icons.favorite,
                    gradient: const [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
                    count: widget.controller.favoriteCourses.length,
                  ),
                  SizedBox(height: responsivity.largeSpacing()),
                ],
                _buildCategorySection(
                  title: 'Fiscais',
                  courses: widget.controller.fiscalCourses,
                  icon: Icons.account_balance,
                  gradient: const [Color(0xFF4A90E2), Color(0xFF357ABD)],
                  count: widget.controller.fiscalCourses.length,
                ),
                SizedBox(height: responsivity.largeSpacing()),
                _buildCategorySection(
                  title: 'Contábeis',
                  courses: widget.controller.contabilCourses,
                  icon: Icons.calculate,
                  gradient: const [Color(0xFF7B68EE), Color(0xFF5A4FCF)],
                  count: widget.controller.contabilCourses.length,
                ),
                SizedBox(height: responsivity.largeSpacing()),
                _buildCategorySection(
                  title: 'Trabalhistas',
                  courses: widget.controller.trabalhistaCourses,
                  icon: Icons.work,
                  gradient: const [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
                  count: widget.controller.trabalhistaCourses.length,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required List<CourseModel> courses,
    required IconData icon,
    required List<Color> gradient,
    required int count,
  }) {
    final responsivity = ResponsivityUtils(context);
    if (courses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: responsivity.responsiveAllPadding(
            ResponsivityConstants.defaultSpacingPercentage,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: responsivity.responsiveBorderRadius(
              ResponsivityConstants.defaultSpacingPercentage,
            ),
            boxShadow: [
              BoxShadow(
                color: gradient[1].withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: responsivity.largeIconSize(),
                height: responsivity.largeIconSize(),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: responsivity.responsiveBorderRadius(
                    ResponsivityConstants.smallSpacingPercentage,
                  ),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                ),
                child: Icon(icon, color: Colors.white, size: responsivity.mediumIconSize()),
              ),
              SizedBox(width: responsivity.defaultSpacing()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: responsivity.largeTextSize(),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: responsivity.smallSpacing()),
                    Text(
                      'Explore ${count > 1 ? '$count cursos' : '1 curso'}',
                      style: TextStyle(
                        fontSize: responsivity.textSize(),
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: responsivity.responsivePadding(
                  horizontalPercentage: 0.03,
                  verticalPercentage: 0.015,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: responsivity.responsiveBorderRadius(0.05),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsivity.textSize(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: responsivity.defaultSpacing()),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...courses.map((course) {
                return CourseItemWidget(
                  course: course,
                  onCourseTap: (courseId) {
                    Navigator.of(context)
                        .pushNamed(
                          AppRoutesManager.courseDetails,
                          arguments: {'courseId': courseId},
                        )
                        .then((result) {
                          if (result is Map<String, dynamic> &&
                              result['favoritesChanged'] == true) {
                            widget.controller.updateFavoriteCourses();
                          }
                        });
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
