import 'package:cruise/main.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:cruise/util/shared/widgets.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/shared/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              color: MyColors.lightYellow,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cruise',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: context.responsive.fontSize * 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right half with black color
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18)),
                  color: MyColors.black),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsive.padding.horizontal * 0.2,
                  vertical: context.responsive.padding.vertical * 0.4,
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ActionButton(
                        height: 50,
                        message: 'LOGIN TO CRUISE',
                        action: () =>
                            GoRouter.of(context).push(AppRouter.kLoginScreen),
                        textStyle: GoogleFonts.crimsonText(
                          fontSize: context.responsive.fontSize * 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ActionButton(
                        height: 50,
                        message: 'Sign Up- User',
                        action: () {
                          GoRouter.of(context).push(AppRouter.kRegisterScreen);
                        },
                        textStyle: GoogleFonts.crimsonText(
                          fontSize: context.responsive.fontSize * 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15),
                          child: Text(
                            "or",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ActionButton(
                        prefixIcon:
                            SvgPicture.asset('assets/svgs/google_icon.svg'),
                        height: 50,
                        message: 'Continue with Google',
                        action: () {},
                        textStyle: GoogleFonts.crimsonText(
                          fontSize: context.responsive.fontSize * 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ActionButton(
                      prefixIcon:
                          SvgPicture.asset('assets/svgs/apple_icon.svg'),
                      height: 50,
                      message: 'Continue with Apple',
                      action: () {},
                      textStyle: GoogleFonts.crimsonText(
                        fontSize: context.responsive.fontSize * 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
