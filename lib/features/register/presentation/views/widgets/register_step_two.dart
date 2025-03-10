import 'package:cruise/features/register/presentation/manager/register_bloc.dart';
import 'package:cruise/features/register/presentation/views/widgets/action_button.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterStepTwo extends StatelessWidget {
  const RegisterStepTwo({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive.pageLayoutHorizontalPadding,
          vertical: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Text(
              'Set up your profile',
              style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            CustomTextField(hint: 'Email', controller: emailController),
            const SizedBox(height: 20),
            CustomTextField(hint: 'Password', controller: passwordController),
            const SizedBox(height: 20),
            CustomTextField(
                hint: 'Confirm Password',
                controller: confirmPasswordController),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RegisterActionButton(
                  action: onPrevious,
                  message: "Back",
                  color: Colors.grey,
                  size: MediaQuery.of(context).size.width * 0.4,
                ),
                BlocListener<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterStepTwoStateSuccess) {
                      onNext();
                    } else if (state is RegisterStepTwoStateFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: RegisterActionButton(
                    action: () {
                      context.read<RegisterBloc>().add(
                            RegisterStepTwoSubmitted(
                              email: emailController.text,
                              password: passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                            ),
                          );
                    },
                    message: 'Next',
                    size: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
