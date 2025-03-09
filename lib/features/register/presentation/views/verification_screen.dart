import 'package:cruise/features/register/presentation/views/widgets/verification_widget.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen(
      {super.key,
      required this.onPrevious,
      required this.onNext,
      required this.title,
      required this.subtitle});
  final Function() onNext;
  final Function() onPrevious;
  final String title;
  final String subtitle;
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
            CustomAppBar(
              children: [
                GestureDetector(
                  onTap: onPrevious,
                  child: Icon(
                    size: context.responsive.iconSize * 0.6,
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: VerificationWidget(
                title: title,
                subtitle: subtitle,
                onComplete: (otp) => onNext(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
