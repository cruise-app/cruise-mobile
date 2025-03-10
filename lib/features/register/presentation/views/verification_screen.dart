import 'package:cruise/features/register/presentation/views/widgets/action_button.dart';
import 'package:cruise/features/register/presentation/views/widgets/verification_widget.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen(
      {super.key,
      required this.onPrevious,
      required this.onNext,
      required this.title,
      required this.subtitle});
  final Function(String) onNext;
  final Function onPrevious;
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
            const SizedBox(height: 20),
            VerificationWidget(
              title: title,
              subtitle: subtitle,
              onComplete: onNext,
            ),
            const SizedBox(height: 30),
            RegisterActionButton(
              action: () {
                onPrevious();
              },
              message: 'Back',
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
