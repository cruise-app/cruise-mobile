import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

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
