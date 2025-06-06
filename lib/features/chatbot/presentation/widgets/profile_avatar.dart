import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/message.dart';

class ProfileAvatar extends StatelessWidget {
  final MessageSender sender;
  final String? avatarUrl;
  final double size;
  final bool isActive;

  const ProfileAvatar({
    Key? key,
    required this.sender,
    this.avatarUrl,
    this.size = 40.0,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getAvatarColor(),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    // If it's a bot and no avatar URL, show bot icon
    if (sender == MessageSender.bot && (avatarUrl == null || avatarUrl!.isEmpty)) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        color: AppColors.primaryColor,
        child: const Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
        ),
      );
    }
    
    // If it's a user and no avatar URL, show user icon
    if (sender == MessageSender.user && (avatarUrl == null || avatarUrl!.isEmpty)) {
      return Container(
        color: AppColors.secondaryColor,
        child: const Icon(
          Icons.person,
          color: Colors.white,
        ),
      );
    }
    
    // If there's an avatar URL, display the image
    return Stack(
      children: [
        Image.network(
          avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: _getAvatarColor(),
              child: Icon(
                sender == MessageSender.bot ? Icons.smart_toy_rounded : Icons.person,
                color: Colors.white,
                size: size * 0.6,
              ),
            );
          },
        ),
        if (isActive)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: AppColors.successColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getAvatarColor() {
    if (sender == MessageSender.bot) {
      return AppColors.primaryColor;
    } else {
      return AppColors.secondaryColor;
    }
  }
}
