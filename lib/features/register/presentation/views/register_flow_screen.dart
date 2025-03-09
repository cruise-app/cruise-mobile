import 'package:cruise/features/register/presentation/views/widgets/register_step_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cruise/features/register/presentation/manager/register_bloc.dart';
import 'package:cruise/features/register/presentation/views/verification_screen.dart';
import 'package:cruise/features/register/presentation/views/phone_verification_screen.dart';
import 'package:cruise/features/register/presentation/views/register_screen.dart';

class RegisterFlowScreen extends StatelessWidget {
  const RegisterFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        List<Page> pages = [
          const MaterialPage(child: RegisterScreen()),
        ];

        return Navigator(
          pages: pages,
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            return true;
          },
        );
      },
    );
  }
}
