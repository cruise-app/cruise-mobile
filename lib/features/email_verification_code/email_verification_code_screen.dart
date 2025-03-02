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

class EmailVerificationCodeScreen extends StatelessWidget {
  const EmailVerificationCodeScreen({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              const CustomAppBar(
                children: [
                  //GoBackButton(color: Colors.white,)
                  GoBackButton(
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Text(
                textAlign: TextAlign.left,
                'Enter Verification Code',
                style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Text(
                'Enter code that we have sent to your email',
                style: GoogleFonts.cabin(color: Colors.grey),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Enter OTP',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Center(
                    child: Pinput(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      length: 4, // Set the number of digits for the OTP
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
                          color: MyColors
                              .lightGrey, // Optional: Set a background color
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
                      submittedPinTheme: PinTheme(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.08,
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
                      onCompleted: (pin) {
                        // Handle the completed OTP input
                        GoRouter.of(context).pushReplacement(AppRouter.kCreatePasswordScreen);
                        print('Entered OTP: $pin');

                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
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


              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
