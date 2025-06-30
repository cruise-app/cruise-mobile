import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'profile_screen.dart';

class FollowListScreen extends StatelessWidget {
  final String userId;
  final String currentUserId;
  final List<dynamic> users;
  final String title;

  const FollowListScreen({
    super.key,
    required this.userId,
    required this.currentUserId,
    required this.users,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(user['username']),
            onTap: () {
              if (user['_id'] != currentUserId) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      userId: user['_id'],
                      currentUserId: currentUserId,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
