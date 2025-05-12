import 'package:flutter/material.dart';

class PageLayout extends StatelessWidget {
  final Widget children;
  const PageLayout({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFF6F2EB),
        body: SafeArea(
          child: children,
        ),
      ),
    );
  }
}
