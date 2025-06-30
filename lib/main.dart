import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF161616),
        colorScheme: const ColorScheme.dark(
          background: Color(0xFF161616),
          surface: Color(0xFF292929),
          primary: Color(0xFFB38E07),
          secondary: Color(0xFFD9D9D9),
          tertiary: Color(0xFFBDBDBD),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFD9D9D9)),
          bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
          bodySmall: TextStyle(color: Color(0xFFBDBDBD)),
          titleLarge: TextStyle(color: Color(0xFFD9D9D9), fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Color(0xFFD9D9D9)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF292929),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFB38E07)),
          ),
          labelStyle: const TextStyle(color: Color(0xFFBDBDBD)),
          hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB38E07),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD9D9D9),
            side: const BorderSide(color: Color(0xFFD9D9D9)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFD9D9D9),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161616),
          foregroundColor: Color(0xFFD9D9D9),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
