import 'dart:collection';

import 'package:cruise/features/register/presentation/views/verification_screen.dart';
import 'package:cruise/features/register/presentation/views/widgets/action_button.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_three.dart';
import 'package:cruise/features/register/presentation/views/widgets/verification_widget.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterStepTwo extends StatelessWidget {
  const RegisterStepTwo(
      {super.key,
      required this.onNext,
      required this.onPrevious,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});
  final Function() onNext;
  final Function() onPrevious;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  @override
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive.pageLayoutHorizontalPadding,
            vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Text('Set up your profile',
                style: GoogleFonts.poppins(
                    fontSize: 28, fontWeight: FontWeight.w600)),
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
                  action: () => Navigator.pop(context),
                  message: "Back",
                  color: Colors.grey,
                  size: MediaQuery.of(context).size.width * 0.4,
                ),
                RegisterActionButton(
                  action: () => onNext,
                  message: 'Next',
                  size: MediaQuery.of(context).size.width * 0.4,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
