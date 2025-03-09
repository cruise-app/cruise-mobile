import 'package:cruise/features/register/presentation/views/widgets/register_step_one.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_two.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _goToNextStep() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => const RegisterStepTwo()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => RegisterStepOne(onNext: _goToNextStep),
        ),
      ),
    );
  }
}
