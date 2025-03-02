import 'package:flutter/cupertino.dart';

class WelcomingMessage extends StatelessWidget {
  const WelcomingMessage({
    super.key,
    required this.welcomeMessage,
    required this.instructionMessage,
  });
  final String welcomeMessage;
  final String instructionMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            welcomeMessage,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            instructionMessage,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}