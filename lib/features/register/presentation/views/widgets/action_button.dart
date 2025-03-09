import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterActionButton extends StatelessWidget {
  const RegisterActionButton(
      {super.key,
      required this.action,
      this.color,
      this.textStyle,
      required this.message,
      this.size});

  final Function() action;
  final Color? color;
  final TextStyle? textStyle;
  final String message;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? double.infinity,
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? MyColors.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          message,
          style: textStyle ??
              GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
        ),
      ),
    );
  }
}
