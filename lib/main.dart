import 'package:cruise/core/di/service_locator.dart';
import 'package:cruise/core/theme/app_colors.dart';
import 'package:cruise/features/login/data/models/user_model.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:hive/hive.dart';

void main() async {
  // Open a box for user data
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  await setupServiceLocator();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(UserModelAdapter());
  // await Hive.openBox<UserModel>('userData');
  // await Hive.openBox<String>('token');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
    return Sizer(
      // ✅ Wrap with Sizer to initialize it
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          title: 'Carpooling App',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
