

import 'package:cruise/util/responsive_manager/responsive_init.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  final List<Widget> children;
  const CustomAppBar({
    super.key, required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}


