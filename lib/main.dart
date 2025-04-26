import 'package:cruise/features/login/data/models/user_model.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:hive/hive.dart';

void main() async {
  // Open a box for user data
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(UserModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
