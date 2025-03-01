// lib/utils/responsive_extension.dart
import 'package:cruise/util/responsive_manager/responsive_utils.dart';
import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
 // Get all responsive parameters
 ResponsiveParams get responsive => ResponsiveUtils.getResponsiveParams(this);

 // Get device type
 DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);

 // Convenience getters for device type checks
 bool get isMobile => deviceType == DeviceType.mobile;
 bool get isTablet => deviceType == DeviceType.tablet;
 bool get isDesktop => deviceType == DeviceType.desktop;

 // Convenience getters for specific parameters
 double get responsiveHeight => responsive.containerHeight;
 double get responsiveWidth => responsive.containerWidth;
 double get fontSize => responsive.fontSize;
 double get iconSize => responsive.iconSize;
 EdgeInsets get responsivePadding => responsive.padding;
 double get pageLayoutHorizontalPadding => responsive.pageLayoutHorizontalPadding;

 // Screen dimensions (using MediaQuery directly)
 Size get screenSize => MediaQuery.of(this).size;
 double get screenWidth => screenSize.width;
 double get screenHeight => screenSize.height;
 EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;
 EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
}
