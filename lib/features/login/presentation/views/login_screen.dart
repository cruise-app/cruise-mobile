import 'package:cruise/features/login/presentation/manager/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cruise/util/shared/widgets.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/widgets/AuthSwitcherButton.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:cruise/features/login/presentation/views/widgets/bottom_alternative.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          print('Login Success');
          GoRouter.of(context)
              .pushReplacement(AppRouter.kBottomNavigationScreen);
        } else if (state is LoginFailureState) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            // Main Page Layout
            PageLayout(
              children: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            context.responsive.pageLayoutHorizontalPadding,
                      ),
                      child: Column(
                        children: [
                          CustomAppBar(
                            children: [
                              const GoBackButton(),
                              AuthSwitcherButton(
                                message: 'Sign Up',
                                action: () => GoRouter.of(context)
                                    .pushReplacement(AppRouter.kRegisterFlow),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Sign into your\nAccount',
                                textAlign: TextAlign.left,
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
                          topLeft: Radius.circular(18),
                        ),
                        color: MyColors.black,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              context.responsive.padding.horizontal * 0.2,
                          vertical: context.responsive.padding.vertical * 0.4,
                        ),
                        child: Column(
                          children: [
                            CustomTextField(
                              hint: 'Email',
                              controller: emailController,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              hint: 'Password',
                              isPassword: true,
                              controller: passwordController,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                BottomAlternative(
                                  question: "Forgot Password",
                                  message: '',
                                  action: () => GoRouter.of(context)
                                      .push(AppRouter.kForgetPasswordScreen),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            ActionButton(
                              message: 'SIGN IN',
                              action: () {
                                final bloc = context.read<LoginBloc>();
                                bloc.add(LoginSubmitted(
                                  email: emailController.text
                                      .trim(), // Replace with user input
                                  password: passwordController.text
                                      .trim(), // Replace with user input
                                ));
                              },
                              textStyle: GoogleFonts.poppins(fontSize: 16),
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
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ActionButton(
                                prefixIcon: SvgPicture.asset(
                                    'assets/svgs/google_icon.svg'),
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
                              prefixIcon: SvgPicture.asset(
                                  'assets/svgs/apple_icon.svg'),
                              height: 50,
                              message: 'Continue with Apple',
                              action: () {},
                              textStyle: GoogleFonts.crimsonText(
                                fontSize: context.responsive.fontSize * 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 25),
                            BottomAlternative(
                              question: "Don't have an account?",
                              message: 'Sign up',
                              action: () => {
                                GoRouter.of(context)
                                    .pushReplacement(AppRouter.kRegisterFlow),
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading Overlay
            if (state is LoginLoadingState)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }
}
