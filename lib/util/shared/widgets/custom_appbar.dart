import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final List<Widget> children;
  const CustomAppBar({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
