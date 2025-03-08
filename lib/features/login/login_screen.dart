import 'package:cruise/features/login/widgets/bottom_alternative.dart';
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
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.responsive.pageLayoutHorizontalPadding),
              child: Column(
                children: [
                  CustomAppBar(
                    children: [
                      const GoBackButton(),
                      AuthSwitcherButton(
                        message: 'Sign Up',
                        action: () => GoRouter.of(context)
                            .pushReplacement(AppRouter.kRegisterScreen),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        'Sign into your\nAccount',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    topLeft: Radius.circular(18)),
                color: MyColors.black,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsive.padding.horizontal * 0.2,
                  vertical: context.responsive.padding.vertical * 0.4,
                ),
                child: Column(
                  children: [
                    const CustomTextField(
                      hint: 'Username',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const CustomTextField(
                      hint: 'Password',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BottomAlternative(
                            question: "Forgot Password",
                            message: '',
                            action: () => GoRouter.of(context)
                                .push(AppRouter.kForgetPasswordScreen)),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ActionButton(
                      message: 'SIGN IN',
                      action: () => GoRouter.of(context).pushReplacement(
                        AppRouter.kLoginScreen,
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                      ),
                      height: 50,
                    ),
                    Row(
                      children: <Widget>[
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15),
                          child: Text(
                            "or",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ActionButton(
                        prefixIcon:
                            SvgPicture.asset('assets/svgs/google_icon.svg'),
                        height: 50,
                        message: 'Continue with Google',
                        action: () {},
                        textStyle: GoogleFonts.crimsonText(
                          fontSize: context.responsive.fontSize * 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ActionButton(
                      prefixIcon:
                          SvgPicture.asset('assets/svgs/apple_icon.svg'),
                      height: 50,
                      message: 'Continue with Apple',
                      action: () {},
                      textStyle: GoogleFonts.crimsonText(
                        fontSize: context.responsive.fontSize * 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    BottomAlternative(
                      question: "Don't have an account",
                      message: 'Sign up',
                      action: () => {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
