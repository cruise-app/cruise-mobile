import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveUtils {
  // Determine device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 600) return DeviceType.mobile;
    if (width < 1200) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  // Get responsive parameters based on device type
  static ResponsiveParams getResponsiveParams(BuildContext context) {
    DeviceType deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return ResponsiveParams(
          containerHeight: 12.5.h,
          containerWidth: 100.w,
          fontSize: 14.sp,
          iconSize: 24.sp,
          pageLayoutHorizontalPadding: 5.w, // Fixed the colon to a comma
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          pageMargin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        );
      case DeviceType.tablet:
        return ResponsiveParams(
          containerHeight: 20.5.h,
          containerWidth: 100.w,
          fontSize: 16.sp,
          iconSize: 28.sp,
          pageLayoutHorizontalPadding: 5.w, // Fixed the colon to a comma
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          pageMargin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        );
      case DeviceType.desktop:
        return ResponsiveParams(
          containerHeight: 15.h,
          containerWidth: 80.w,
          fontSize: 18.sp,
          iconSize: 32.sp,
          pageLayoutHorizontalPadding: 5.w, // Fixed the colon to a comma
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
          pageMargin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        );
    }
  }
}

// Class to hold all responsive parameters
class ResponsiveParams {
  final double containerHeight;
  final double containerWidth;
  final double fontSize;
  final double iconSize;
  final EdgeInsets padding;
  final EdgeInsets pageMargin;
  final double pageLayoutHorizontalPadding;

  ResponsiveParams({
    required this.containerHeight,
    required this.containerWidth,
    required this.fontSize,
    required this.iconSize,
    required this.padding,
    required this.pageMargin,
    required this.pageLayoutHorizontalPadding, // Added the missing parameter
  });
}
