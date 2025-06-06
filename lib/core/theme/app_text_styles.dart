import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation
  
  // Headings
  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColorWhite,
    letterSpacing: -0.5,
  );
  
  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColorWhite,
    letterSpacing: -0.5,
  );
  
  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textColorWhite,
    letterSpacing: -0.5,
  );
  
  // Body Text
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColorWhite,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColorWhite,
  );
  
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColorLight,
  );
  
  // Button Text
  static TextStyle get buttonLarge => GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static TextStyle get buttonMedium => GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // Label Text
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textColorLight,
  );
  
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textColorLight,
  );
  
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textColorLight,
  );
  
  // Chat Text
  static TextStyle get chatMessageUser => GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  
  static TextStyle get chatMessageBot => GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColorDark,
  );
  
  static TextStyle get chatTimestamp => GoogleFonts.inter(
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColorLight.withOpacity(0.7),
  );
  
  // Tab Text
  static TextStyle get tabSelected => GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );
  
  static TextStyle get tabUnselected => GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColorLight,
  );
}
