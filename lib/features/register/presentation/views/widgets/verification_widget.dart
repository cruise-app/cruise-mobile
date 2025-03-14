import 'package:cruise/features/register/presentation/manager/register_bloc.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class VerificationWidget extends StatelessWidget {
  const VerificationWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onComplete,
      required this.toVerify});

  final String title;
  final String subtitle;
  final Function(String) onComplete;
  final String toVerify;

  @override
  Widget build(BuildContext context) {
    return Column(
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

        // BlocListener should wrap Pinput
        BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is OtpVerificationStateSuccess) {
              onComplete(''); // Pass the OTP that was verified
            } else if (state is OtpVerificationStateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Center(
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
              onCompleted: (String otp) {
                context.read<RegisterBloc>().add(
                      ToVerifySubmitted(toVerify: toVerify, otp: otp),
                    );
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        Center(
          child: GestureDetector(
            onTap: () {
              // Add logic to resend the OTP
            },
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
    );
  }
}
