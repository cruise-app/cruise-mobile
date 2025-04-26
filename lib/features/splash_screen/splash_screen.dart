import 'package:cruise/features/lobby/lobby_screen.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    var box = await Hive.openBox('userBox');
    String? token = box.get('token');
    print("Token: $token");
    if (token != null) {
      // User is logged in, navigate to home screen
      if (mounted) {
        GoRouter.of(context).pushReplacement(AppRouter.kBottomNavigationScreen);
      }
    } else {
      print("Entering lobby screen");
      // User is not logged in, navigate to lobby screen

      print("Entering lobby screen");
      if (mounted) {
        GoRouter.of(context).pushReplacement(AppRouter.kLobbyScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/logo.png',
            //   width: 100,
            //   height: 100,
            // ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Carpooling App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
