import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/constants/responsivity_constants.dart';
import 'package:lxp_platform/core/utils/responsivity_utils.dart';
import 'package:lxp_platform/data/models/course_model.dart';

class CourseItemWidget extends StatelessWidget {
  final CourseModel course;
  final Function(String) onCourseTap;

  const CourseItemWidget({super.key, required this.course, required this.onCourseTap});

  @override
  Widget build(BuildContext context) {
    final responsivity = ResponsivityUtils(context);
    return Container(
      width: responsivity.cardWidth(),
      margin: EdgeInsets.only(right: responsivity.smallSpacing()),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: responsivity.responsiveBorderRadius(
            ResponsivityConstants.defaultSpacingPercentage,
          ),
          side: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: responsivity.responsiveBorderRadius(
            ResponsivityConstants.defaultSpacingPercentage,
          ),
          onTap: () => onCourseTap(course.id),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                _buildBannerBackground(context),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: responsivity.responsiveBorderRadius(
                      ResponsivityConstants.defaultSpacingPercentage,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
                if (_hasNoBanner())
                  Positioned(
                    bottom: responsivity.smallSpacing(),
                    left: responsivity.defaultSpacing(),
                    right: responsivity.defaultSpacing(),
                    child: Text(
                      course.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsivity.textSize(),
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0)),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _hasNoBanner() {
    return course.banner == null || course.banner!.isEmpty;
  }

  Widget _buildBannerBackground(BuildContext context) {
    final responsivity = ResponsivityUtils(context);
    if (course.banner != null && course.banner!.isNotEmpty) {
      return ClipRRect(
        borderRadius: responsivity.responsiveBorderRadius(
          ResponsivityConstants.defaultSpacingPercentage,
        ),
        child: CachedNetworkImage(
          imageUrl: course.banner!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildLoadingPlaceholder(),
          errorWidget: (context, url, error) => _buildPlaceholder(context),
        ),
      );
    } else {
      return _buildPlaceholder(context);
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    final responsivity = ResponsivityUtils(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: responsivity.responsiveBorderRadius(
          ResponsivityConstants.defaultSpacingPercentage,
        ),
        color: Theme.of(context).cardColor,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Theme.of(context).colorScheme.primary, Colors.black54],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.school,
          size: responsivity.largeIconSize(),
          color: const Color(0xFF4A90E2),
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.grey[900]),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
