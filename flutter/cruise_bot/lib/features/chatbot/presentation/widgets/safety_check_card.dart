import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SafetyCheckCard extends StatelessWidget {
  final String title;
  final String recommendation;
  final bool isPassing;
  final VoidCallback onAction;
  final String actionLabel;

  const SafetyCheckCard({
    Key? key,
    required this.title,
    required this.recommendation,
    this.isPassing = true,
    required this.onAction,
    this.actionLabel = 'I\'m Safe',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 4.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isPassing ? AppColors.successColor : AppColors.errorColor,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isPassing
                  ? AppColors.successColor.withOpacity(0.1)
                  : AppColors.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPassing ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: isPassing ? AppColors.successColor : AppColors.errorColor,
                  size: 24.0,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: isPassing ? AppColors.successColor : AppColors.errorColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              recommendation,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          
          // Action button
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPassing
                      ? AppColors.successColor
                      : AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
