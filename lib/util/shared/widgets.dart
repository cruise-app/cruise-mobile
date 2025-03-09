import 'package:cruise/features/register/presentation/views/widgets/register_step_one.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.message,
    required this.action,
    required this.textStyle,
    this.color,
    required this.height,
    this.prefixIcon,
  });

  final String message;
  final Function() action;
  final Color? color;
  final TextStyle textStyle;
  final double height;
  final SvgPicture? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color ?? MyColors.lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16), // Add padding for the icon
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left-aligned prefix icon
            Visibility(
              visible: prefixIcon != null,
              child: prefixIcon ?? const SizedBox.shrink(),
            ),
            // Centered text
            Expanded(
              child: Center(
                child: Text(
                  message,
                  style: textStyle,
                ),
              ),
            ),
            // Placeholder to maintain alignment
            prefixIcon != null
                ? Opacity(opacity: 0, child: prefixIcon)
                : const SizedBox(width: 0), // Adjust width to match icon size
          ],
        ),
      ),
    );
  }
}
