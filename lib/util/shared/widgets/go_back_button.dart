import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key, this.color = Colors.black});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: GoRouter.of(context).pop,
      child: Icon(
        size: context.responsive.iconSize * 0.8,
        CupertinoIcons.back,
        color: color,
      ),
    );
  }
}
