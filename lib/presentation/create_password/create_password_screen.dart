import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CreatePasswordScreen extends StatelessWidget {
  const CreatePasswordScreen({super.key});

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
                'Create Password',
                style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Text(
                'Create your new password to login',
                style: GoogleFonts.cabin(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomTextField(
                hint: 'Password',
                isPassword: true,
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomTextField(
                hint: 'Confirm Password',
                isPassword: true,
              ),
              const SizedBox(
                height: 40,
              ),
              ActionButton(message: 'CREATE PASSWORD', action: ()=>{}, textStyle: GoogleFonts.poppins(
                fontSize: 16
              ), height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
