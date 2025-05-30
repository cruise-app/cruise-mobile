import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final bool isHighlighted;

  const RecommendationCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 4.0,
        ),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.primaryColorLight : AppColors.cardColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isHighlighted ? AppColors.primaryColor : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppColors.primaryColor
                    : AppColors.primaryColorLight,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                icon,
                color: isHighlighted ? Colors.white : AppColors.primaryColor,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 16.0),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Arrow or checkmark
            Icon(
              isHighlighted ? Icons.check_circle : Icons.arrow_forward_ios,
              color: isHighlighted
                  ? AppColors.successColor
                  : AppColors.iconColor.withOpacity(0.5),
              size: isHighlighted ? 24.0 : 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
