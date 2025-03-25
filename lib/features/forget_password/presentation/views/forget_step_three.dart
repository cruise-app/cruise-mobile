import 'package:cruise/features/forget_password/presentation/manager/forget_password_bloc.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetStepThree extends StatelessWidget {
  const ForgetStepThree(
      {super.key,
      required this.emailController,
      required this.onBack,
      required this.onNext,
      required this.passwordController,
      required this.confirmPasswordController});
  final TextEditingController emailController;
  final void Function() onBack;
  final void Function() onNext;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset successfully!')),
          );
          onNext();
        } else if (state is ForgetPasswordFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: PageLayout(
        children: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: MyColors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.responsive.pageLayoutHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                const CustomAppBar(
                  children: [GoBackButton(color: Colors.white)],
                ),
                const SizedBox(height: 35),
                Text(
                  'Create Password',
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                Text('Create your new password to login',
                    style: GoogleFonts.cabin(color: Colors.grey)),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  hint: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: confirmPasswordController,
                  hint: 'Confirm Password',
                  isPassword: true,
                ),
                const SizedBox(height: 40),
                ActionButton(
                  message: 'CREATE PASSWORD',
                  action: () {
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Passwords do not match!')),
                      );
                      return;
                    }
                    context.read<ForgetPasswordBloc>().add(
                          NewPasswordSubmitted(
                              email: emailController.text,
                              password: passwordController.text,
                              confirmPassword: confirmPasswordController.text),
                        );
                  },
                  textStyle: GoogleFonts.poppins(fontSize: 16),
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
