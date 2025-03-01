import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class BottomAlternative extends StatelessWidget {
  const BottomAlternative({
    super.key,
    required this.question,
    required this.message,
    required this.action,
  });
  final String question;
  final String message;
  final Function() action;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: action,
          child: Text(
            '$question?$message',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        )
      ],
    );
  }
}