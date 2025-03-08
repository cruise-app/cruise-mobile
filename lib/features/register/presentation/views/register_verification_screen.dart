import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class RegisterVerificationScreen extends StatelessWidget {
  const RegisterVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive.pageLayoutHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            const CustomAppBar(
              children: [
                GoBackButton(color: Colors.black),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: VerificationWidget(
                title: 'Verify your email',
                subtitle: 'Enter the code sent to your email',
                onComplete: (otp) {
                  // Navigate or handle email verification logic
                  GoRouter.of(context).push(AppRouter.kCreatePasswordScreen);
                },
              ),
            ),
            const Divider(
              color: MyColors.lightGrey,
              thickness: 1,
              height: 30,
            ),
            Expanded(
              child: VerificationWidget(
                title: 'Verify your phone number',
                subtitle: 'Enter the code sent to your phone',
                onComplete: (otp) {
                  // Navigate or handle phone verification logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerificationWidget extends StatelessWidget {
  const VerificationWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onComplete,
  });

  final String title;
  final String subtitle;
  final Function(String) onComplete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: MyColors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.cabin(color: MyColors.black),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Pinput(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    length: 4,
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 20,
                        color: MyColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    ),
                    onCompleted: onComplete,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Didn't receive code? Resend",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: MyColors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
