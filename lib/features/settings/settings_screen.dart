import 'package:cruise/util/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            var box = Hive.box('userBox'); // Clear the Hive box
            box.delete('token');
            box.delete('userModel');
            GoRouter.of(context).pushReplacement(
                AppRouter.kLobbyScreen); // Navigate back to the previous screen
          },
          child: const Text('Logout'),
        ),
        ElevatedButton(
            onPressed: () {
              GoRouter.of(context).push(AppRouter.kChatBotScreen);
            },
            child: const Text('Chat bot')),
      ],
    );
  }
}
