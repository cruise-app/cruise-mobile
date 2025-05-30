import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/config/routes.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize service locator
  await setupServiceLocator();
  
  runApp(const CruiseBotApp());
}

class CruiseBotApp extends StatelessWidget {
  const CruiseBotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Force recreate the theme to ensure the new colors are applied
    final appTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        background: AppColors.backgroundDark,
        surface: AppColors.cardColor,
        error: AppColors.errorColor,
      ),
    );
    
    return MaterialApp(
      title: 'Cruise Bot',
      debugShowCheckedModeBanner: false,
      theme: appTheme, // Use our explicitly created theme
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: AppRoutes.dashboard,
    );
  }
}
