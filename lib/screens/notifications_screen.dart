import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'profile_screen.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;

  const NotificationsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _apiService = ApiService();
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final notifications = await _apiService.getNotifications(widget.userId);
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notifications: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleFollowRequest(
      String requesterId, String notificationId, bool accept) async {
    try {
      if (accept) {
        await _apiService.acceptFollowRequest(
            widget.userId, requesterId, notificationId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Follow request accepted')),
          );
        }
      } else {
        await _apiService.declineFollowRequest(
            widget.userId, requesterId, notificationId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Follow request declined')),
          );
        }
      }

      // Remove the notification from the local list
      setState(() {
        _notifications.removeWhere(
            (notification) => notification['_id'] == notificationId);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB38E07)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        color: const Color(0xFFB38E07),
        child: _notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: Color(0xFFBDBDBD),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildNotificationItem(_notifications[index]),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final sender = notification['sender'] as Map<String, dynamic>;
    final type = notification['type'] as String;
    final createdAt = DateTime.parse(notification['createdAt'] as String);
    final timeAgo = DateTime.now().difference(createdAt);
    String timeString;

    if (timeAgo.inMinutes < 60) {
      timeString = '${timeAgo.inMinutes}m';
    } else if (timeAgo.inHours < 24) {
      timeString = '${timeAgo.inHours}h';
    } else {
      timeString = '${timeAgo.inDays}d';
    }

    Widget? trailing;
    String message;
    IconData notificationIcon;

    switch (type) {
      case 'follow_request':
        message = '${sender['username']} wants to follow you';
        notificationIcon = Icons.person_add_outlined;
        trailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFFB38E07),
              ),
              onPressed: () => _handleFollowRequest(
                  sender['_id'], notification['_id'], true),
            ),
            IconButton(
              icon: const Icon(
                Icons.cancel_outlined,
                color: Color(0xFFBDBDBD),
              ),
              onPressed: () => _handleFollowRequest(
                  sender['_id'], notification['_id'], false),
            ),
          ],
        );
        break;
      case 'follow_accept':
        message = '${sender['username']} accepted your follow request';
        notificationIcon = Icons.person_outline;
        break;
      case 'like':
        message = '${sender['username']} liked your post';
        notificationIcon = Icons.favorite_border;
        break;
      case 'comment':
        message = '${sender['username']} commented on your post';
        notificationIcon = Icons.chat_bubble_outline;
        break;
      default:
        message = 'New notification from ${sender['username']}';
        notificationIcon = Icons.notifications_none;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFB38E07),
        child: Icon(
          notificationIcon,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFD9D9D9),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        timeString,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      trailing: trailing,
      onTap: () {
        if (type != 'follow_request') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userId: sender['_id'],
                currentUserId: widget.userId,
              ),
            ),
          );
        }
      },
    );
  }
}
