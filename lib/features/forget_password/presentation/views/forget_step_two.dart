import 'package:cruise/features/forget_password/presentation/manager/forget_password_bloc.dart';
import 'package:cruise/features/forget_password/presentation/views/forget_step_three.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetStepTwo extends StatelessWidget {
  const ForgetStepTwo(
      {super.key,
      required this.emailController,
      required this.onNext,
      required this.onBack});
  final TextEditingController emailController;
  final void Function() onNext;
  final void Function() onBack;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccessState) {
          // Navigate to Create Password Screen on successful OTP verification
          onNext();
        } else if (state is ForgetPasswordFailureState) {
          // Show error message if OTP verification fails
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
                  'Enter Verification Code',
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                Text(
                  'Enter the code we have sent to your email',
                  style: GoogleFonts.cabin(color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Text('Enter OTP',
                    style: GoogleFonts.poppins(color: Colors.white)),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Center(
                      child: Pinput(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        length: 4, // Set OTP length
                        defaultPinTheme: PinTheme(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.1,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                            color: MyColors.lightGrey,
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.1,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: MyColors.lightYellow),
                            borderRadius: BorderRadius.circular(12),
                            color: MyColors.lightGrey,
                          ),
                        ),
                        onCompleted: (pin) {
                          print("Whats the email: $emailController");
                          print("------------------------");
                          // Dispatch OTP verification event
                          context.read<ForgetPasswordBloc>().add(
                                VerificationCodeSubmitted(
                                    email: emailController.text, otp: pin),
                              );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Didn't receive code?",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: MyColors.lightYellow),
                    ),
                    Text(
                      'Resend',
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: MyColors.lightYellow),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
