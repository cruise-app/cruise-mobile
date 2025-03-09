import 'package:cruise/features/register/presentation/views/widgets/verification_widget.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({super.key});

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
