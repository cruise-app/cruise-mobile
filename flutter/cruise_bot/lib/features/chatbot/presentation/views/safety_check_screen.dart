import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';
import '../widgets/safety_check_card.dart';
import '../widgets/profile_avatar.dart';
import '../../domain/entities/message.dart';

class SafetyCheckScreen extends StatefulWidget {
  const SafetyCheckScreen({Key? key}) : super(key: key);

  @override
  State<SafetyCheckScreen> createState() => _SafetyCheckScreenState();
}

class _SafetyCheckScreenState extends State<SafetyCheckScreen> {
  // Simulated user ID for development
  final String userId = 'user_1234';
  late ChatbotBloc _chatbotBloc;
  
  @override
  void initState() {
    super.initState();
    _chatbotBloc = sl<ChatbotBloc>();
    _chatbotBloc.add(PerformSafetyCheckEvent(userId: userId));
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _chatbotBloc,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              const ProfileAvatar(
                sender: MessageSender.bot,
                size: 36.0,
              ),
              const SizedBox(width: 12.0),
              Text(
                'Safety Checks',
                style: AppTextStyles.headingSmall.copyWith(fontSize: 18.0),
              ),
            ],
          ),
        ),
        body: BlocBuilder<ChatbotBloc, ChatbotState>(
          builder: (context, state) {
            if (state is SafetyCheckLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }
            
            if (state is SafetyCheckLoaded) {
              return _buildSafetyCheckView(state.safetyCheck);
            }
            
            if (state is ChatbotError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.errorColor,
                      size: 48.0,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Failed to perform safety check',
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      state.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textColorLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        _chatbotBloc.add(PerformSafetyCheckEvent(userId: userId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            // Default loading state
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildSafetyCheckView(Map<String, dynamic> safetyCheck) {
    // Mock safety checks for UI
    final mockSafetyChecks = [
      {
        'title': 'Driver Safety Check',
        'recommendation': 'Your driver is en route to pick you up. Driver safety rating: 4.9/5.0',
        'isPassing': true,
        'actionLabel': 'Yes, I\'m Safe',
      },
      {
        'title': 'Location Verification',
        'recommendation': 'We\'ve confirmed your current location matches your pickup point.',
        'isPassing': true,
        'actionLabel': 'Confirm',
      },
      {
        'title': 'Why is my driver so late again?',
        'recommendation': 'I\'m really sorry about that. Let me check and update you immediately.',
        'isPassing': false,
        'actionLabel': 'Need Help',
      },
    ];
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield,
                color: AppColors.successColor,
                size: 32.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safety Checks',
                    style: AppTextStyles.headingMedium,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Ensuring your ride is safe and comfortable',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textColorLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        
        // Safety check cards
        ...mockSafetyChecks.map((check) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SafetyCheckCard(
            title: check['title'] as String,
            recommendation: check['recommendation'] as String,
            isPassing: check['isPassing'] as bool,
            actionLabel: check['actionLabel'] as String,
            onAction: () {
              _chatbotBloc.add(SendMessageEvent(
                message: 'Regarding ${check['title']}: ${(check['isPassing'] as bool) ? "I'm safe" : "I need help"}',
                userId: userId,
              ));
              Navigator.pushNamed(context, AppRoutes.chat);
            },
          ),
        )).toList(),
        
        // Emergency contact button
        const SizedBox(height: 16.0),
        OutlinedButton.icon(
          onPressed: () {
            // Show emergency contact dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.backgroundMedium,
                title: const Text('Emergency Contact'),
                content: const Text('Would you like to contact emergency services?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.chat);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor,
                    ),
                    child: const Text('Contact Emergency'),
                  ),
                ],
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            side: const BorderSide(color: AppColors.errorColor),
          ),
          icon: const Icon(
            Icons.emergency,
            color: AppColors.errorColor,
          ),
          label: Text(
            'Emergency Contact',
            style: const TextStyle(
              color: AppColors.errorColor,
            ),
          ),
        ),
      ],
    );
  }
}
