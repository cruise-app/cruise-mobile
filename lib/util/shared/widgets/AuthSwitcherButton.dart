import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AuthSwitcherButton extends StatelessWidget {
  final String message;
  final Function() action;
  const AuthSwitcherButton({
    super.key, required this.message, required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.responsive.containerWidth * 0.2,
      child: TextButton(
        style: ButtonStyle(
          side: const WidgetStatePropertyAll(
            BorderSide(color: Colors.black87),
          ),
          backgroundColor: WidgetStateProperty.all(Colors.white),
        ),
        onPressed: action,
        child: Text(
          message,
          style: GoogleFonts.cabin(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}