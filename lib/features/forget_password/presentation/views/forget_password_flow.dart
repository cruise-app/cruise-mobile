import 'package:cruise/features/forget_password/presentation/manager/forget_password_bloc.dart';
import 'package:cruise/features/forget_password/presentation/views/forget_step_one.dart';
import 'package:cruise/features/forget_password/presentation/views/forget_step_three.dart';
import 'package:cruise/features/forget_password/presentation/views/forget_step_two.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordParent extends StatelessWidget {
  const ForgetPasswordParent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordBloc(),
      child: ForgetPasswordFlow(),
    );
  }
}

// Flow Manager Widget
class ForgetPasswordFlow extends StatefulWidget {
  const ForgetPasswordFlow({super.key});

  @override
  State<ForgetPasswordFlow> createState() => _ForgetPasswordFlowState();
}

class _ForgetPasswordFlowState extends State<ForgetPasswordFlow> {
  final PageController _pageController = PageController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ForgetStepOne(
            onNext: nextPage,
            emailController: emailController,
          ),
          ForgetStepTwo(
            onNext: nextPage,
            onBack: previousPage,
            emailController: emailController,
          ),
          ForgetStepThree(
              onBack: previousPage,
              emailController: emailController,
              onNext: () {
                GoRouter.of(context).go(AppRouter.kLobbyScreen);
              },
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController),
        ],
      ),
    );
  }
}
