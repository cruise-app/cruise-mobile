import 'package:cruise/features/forget_password/presentation/manager/forget_password_bloc.dart';
import 'package:cruise/features/forget_password/presentation/views/forget_step_two.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetStepOne extends StatefulWidget {
  const ForgetStepOne(
      {super.key, required this.onNext, required this.emailController});
  final Function() onNext;
  final TextEditingController emailController;
  @override
  State<ForgetStepOne> createState() => _ForgetStepOneState();
}

class _ForgetStepOneState extends State<ForgetStepOne> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccessState) {
          widget.onNext();
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
              children: [
                const SizedBox(height: 20),
                CustomAppBar(
                  children: [
                    const GoBackButton(color: Colors.white),
                    AuthSwitcherButton(
                      message: 'Sign In',
                      action: () => GoRouter.of(context)
                          .pushReplacement(AppRouter.kLoginScreen),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Your Password',
                      textAlign: TextAlign.left,
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
                const SizedBox(height: 25),
                CustomTextField(
                  hint: 'Email',
                  controller: widget.emailController,
                ),
                const SizedBox(height: 20),
                BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
                  builder: (context, state) {
                    return ActionButton(
                      message: state is ForgetPasswordLoadingState
                          ? 'SENDING...'
                          : 'RESET MY PASSWORD',
                      action: state is ForgetPasswordLoadingState
                          ? () {}
                          : () {
                              context.read<ForgetPasswordBloc>().add(
                                    EmailSubmitted(
                                        email: widget.emailController.text),
                                  );
                            },
                      textStyle: GoogleFonts.poppins(fontSize: 16),
                      height: 50,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
