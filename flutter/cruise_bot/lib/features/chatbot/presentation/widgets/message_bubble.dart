import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onTap;

  const MessageBubble({
    Key? key,
    required this.message,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final textColor = isUser ? Colors.white : Colors.black;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            left: isUser ? 50.0 : 10.0,
            right: isUser ? 10.0 : 50.0,
            top: 5.0,
            bottom: 5.0,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            color: isUser ? AppColors.primaryColor : AppColors.bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
              bottomLeft: Radius.circular(isUser ? 20.0 : 0.0),
              bottomRight: Radius.circular(isUser ? 0.0 : 20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show the content text
              Text(
                message.content,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.0,
                ),
              ),
              
              // Show timestamp
              const SizedBox(height: 4.0),
              Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
