import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/constants/responsivity_constants.dart';
import 'package:lxp_platform/core/utils/responsivity_utils.dart';
import 'package:lxp_platform/data/models/course_details_model.dart';
import 'package:lxp_platform/features/course_details/controllers/course_details_controller.dart';

class CourseContentWidget extends StatelessWidget {
  final CourseDetailsModel courseDetails;
  final CourseDetailsController controller;
  final VoidCallback onFavoriteChanged;

  const CourseContentWidget({
    super.key,
    required this.courseDetails,
    required this.controller,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final responsivity = ResponsivityUtils(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height:
              responsivity.statusBarHeight +
              responsivity.buttonSize() +
              responsivity.smallSpacing(),
          padding: EdgeInsets.only(
            top: responsivity.statusBarHeight,
            left: responsivity.defaultSpacing(),
            right: responsivity.defaultSpacing(),
          ),
          child: Container(
            width: responsivity.buttonSize(),
            height: responsivity.buttonSize(),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: responsivity.smallIconSize()),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop({'favoritesChanged': true}),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              _buildBannerBackground(context),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
              if (_hasNoBanner())
                Positioned(
                  bottom: responsivity.defaultSpacing(),
                  left: responsivity.defaultSpacing(),
                  right: responsivity.defaultSpacing(),
                  child: Text(
                    courseDetails.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsivity.largeTextSize(),
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0)),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: responsivity.responsiveAllPadding(
            ResponsivityConstants.defaultSpacingPercentage,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (courseDetails.subtitle?.isNotEmpty == true) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        courseDetails.subtitle!,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(color: Colors.grey[300]),
                      ),
                    ),
                    Container(
                      width: responsivity.buttonSize(),
                      height: responsivity.buttonSize(),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          controller.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: controller.isFavorite ? Colors.red : Colors.white,
                          size: responsivity.smallIconSize(),
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          await controller.toggleFavorite();
                          onFavoriteChanged();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsivity.largeSpacing()),
              ],
              if (courseDetails.summary?.isNotEmpty == true) ...[
                Text(
                  'Resumo do Curso',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                SizedBox(height: responsivity.smallSpacing()),
                Text(
                  courseDetails.summary!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[300],
                    height: 1.5,
                    fontSize: responsivity.textSize(),
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: responsivity.largeSpacing()),
              ],
              if (courseDetails.objective?.isNotEmpty == true) ...[
                Text(
                  'Objetivo',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                SizedBox(height: responsivity.smallSpacing()),
                Text(
                  courseDetails.objective!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[300],
                    height: 1.5,
                    fontSize: responsivity.textSize(),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerBackground(BuildContext context) {
    final responsivity = ResponsivityUtils(context);
    if (courseDetails.banner != null && courseDetails.banner!.isNotEmpty) {
      return ClipRRect(
        borderRadius: responsivity.responsiveBorderRadius(
          ResponsivityConstants.defaultSpacingPercentage,
        ),
        child: CachedNetworkImage(
          imageUrl: courseDetails.banner!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildPlaceholder(context, isLoading: true),
          errorWidget: (context, url, error) => _buildPlaceholder(context, isLoading: false),
        ),
      );
    }
    return _buildPlaceholder(context, isLoading: false);
  }

  Widget _buildPlaceholder(BuildContext context, {required bool isLoading}) {
    final responsivity = ResponsivityUtils(context);
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[900],
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
            strokeWidth: 3,
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: responsivity.responsiveBorderRadius(
          ResponsivityConstants.defaultSpacingPercentage,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF4A90E2).withOpacity(0.8), const Color(0xFF121212)],
        ),
      ),
      child: Center(
        child: Icon(Icons.school, size: responsivity.extraLargeIconSize(), color: Colors.white),
      ),
    );
  }

  bool _hasNoBanner() {
    return courseDetails.banner == null || courseDetails.banner!.isEmpty;
  }
}
