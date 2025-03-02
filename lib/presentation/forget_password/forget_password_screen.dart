import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets.dart';
import 'package:cruise/util/shared/widgets/AuthSwitcherButton.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
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
            children: [
              const SizedBox(
                height: 20,
              ),
              CustomAppBar(
                children: [
                  //GoBackButton(color: Colors.white,)
                  const GoBackButton(
                    color: Colors.white,
                  ),
                  AuthSwitcherButton(
                    message: 'Sign In',
                    action: () => GoRouter.of(context)
                        .pushReplacement(AppRouter.kLoginScreen),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.left,
                    'Forgot Your Password',
                    style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
              Text(
                'No worries, you just need to type your email address or username and we will send the verification code.',
                style: GoogleFonts.cabin(color: Colors.grey),
              ),
              const SizedBox(
                height: 25,
              ),
              const CustomTextField(
                hint: 'Email',
              ),
              const SizedBox(
                height: 20,
              ),
              ActionButton(
                  message: 'RESET MY PASSWORD',
                  action: () => GoRouter.of(context)
                      .push(AppRouter.kEmailVerificationCodeScreen),
                  textStyle: GoogleFonts.poppins(fontSize: 16),
                  height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
