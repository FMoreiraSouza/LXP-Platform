import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/constants/responsivity_constants.dart';

class ResponsivityUtils {
  final BuildContext context;

  ResponsivityUtils(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
  double get shortestSide => MediaQuery.of(context).size.shortestSide;
  double get statusBarHeight => MediaQuery.of(context).padding.top;

  double responsiveSize(double percentage, double maxValue) {
    return min(shortestSide * percentage, maxValue);
  }

  EdgeInsets responsivePadding({
    double horizontalPercentage = 0.0,
    double verticalPercentage = 0.0,
    double? horizontalBase,
    double? verticalBase,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontalBase ?? shortestSide * horizontalPercentage,
      vertical: verticalBase ?? shortestSide * verticalPercentage,
    );
  }

  EdgeInsets responsiveAllPadding(double percentage) {
    final value = shortestSide * percentage;
    return EdgeInsets.all(value);
  }

  BorderRadius responsiveBorderRadius(double percentage) {
    return BorderRadius.circular(shortestSide * percentage);
  }

  double defaultSpacing({double multiplier = 1.0}) {
    return responsiveSize(
      ResponsivityConstants.defaultSpacingPercentage * multiplier,
      ResponsivityConstants.defaultSpacingBase * multiplier,
    );
  }

  double smallSpacing() {
    return responsiveSize(
      ResponsivityConstants.smallSpacingPercentage,
      ResponsivityConstants.defaultSpacingBase * 0.5,
    );
  }

  double largeSpacing() {
    return responsiveSize(
      ResponsivityConstants.largeSpacingPercentage,
      ResponsivityConstants.largeSpacingBase,
    );
  }

  double imageSize() {
    return responsiveSize(
      ResponsivityConstants.imageSizePercentage,
      ResponsivityConstants.imageSizeBase,
    );
  }

  double iconSize() {
    return responsiveSize(
      ResponsivityConstants.iconSizePercentage,
      ResponsivityConstants.iconSizeBase,
    );
  }

  double textSize() {
    return responsiveSize(
      ResponsivityConstants.textSizePercentage,
      ResponsivityConstants.textSizeBase,
    );
  }

  double mediumTextSize() {
    return responsiveSize(
      ResponsivityConstants.mediumTextSizePercentage,
      ResponsivityConstants.mediumTextSizeBase,
    );
  }

  double largeTextSize() {
    return responsiveSize(
      ResponsivityConstants.largeTextSizePercentage,
      ResponsivityConstants.largeTextSizeBase,
    );
  }

  double extraLargeTextSize() {
    return responsiveSize(
      ResponsivityConstants.extraLargeTextSizePercentage,
      ResponsivityConstants.extraLargeTextSizeBase,
    );
  }

  double smallIconSize() {
    return responsiveSize(
      ResponsivityConstants.smallIconSizePercentage,
      ResponsivityConstants.smallIconSizeBase,
    );
  }

  double mediumIconSize() {
    return responsiveSize(
      ResponsivityConstants.mediumIconSizePercentage,
      ResponsivityConstants.mediumIconSizeBase,
    );
  }

  double largeIconSize() {
    return responsiveSize(
      ResponsivityConstants.largeIconSizePercentage,
      ResponsivityConstants.largeIconSizeBase,
    );
  }

  double extraLargeIconSize() {
    return responsiveSize(
      ResponsivityConstants.extraLargeIconSizePercentage,
      ResponsivityConstants.extraLargeIconSizeBase,
    );
  }

  double cardWidth() {
    return responsiveSize(
      ResponsivityConstants.cardWidthPercentage,
      ResponsivityConstants.cardWidthBase,
    );
  }

  double buttonSize() {
    return responsiveSize(
      ResponsivityConstants.buttonSizePercentage,
      ResponsivityConstants.buttonSizeBase,
    );
  }
}
