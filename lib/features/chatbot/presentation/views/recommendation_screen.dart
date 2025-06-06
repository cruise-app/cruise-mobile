import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/profile_avatar.dart';
import '../../domain/entities/message.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  // Simulated user ID for development
  final String userId = 'user_1234';
  late ChatbotBloc _chatbotBloc;
  
  @override
  void initState() {
    super.initState();
    _chatbotBloc = sl<ChatbotBloc>();
    _chatbotBloc.add(GetRecommendationsEvent(userId: userId));
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
                'Personalized Recommendation',
                style: AppTextStyles.headingSmall.copyWith(fontSize: 18.0),
              ),
            ],
          ),
        ),
        body: BlocBuilder<ChatbotBloc, ChatbotState>(
          builder: (context, state) {
            if (state is RecommendationsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }
            
            if (state is RecommendationsLoaded) {
              return _buildRecommendationsList(state.recommendations);
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
                      'Failed to load recommendations',
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
                        _chatbotBloc.add(GetRecommendationsEvent(userId: userId));
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
  
  Widget _buildRecommendationsList(List<Map<String, dynamic>> recommendations) {
    if (recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.primaryColor,
              size: 48.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              'No recommendations available',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              'We\'ll provide personalized recommendations based on your ride history.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textColorLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.chat);
              },
              child: const Text('Chat with RideBot'),
            ),
          ],
        ),
      );
    }
    
    // Mock recommendations data for UI
    final mockRecommendations = [
      {
        'title': 'Morning Commute',
        'description': 'Based on your history, we recommend booking a ride to Downtown for your morning commute.',
        'icon': Icons.wb_sunny,
      },
      {
        'title': 'Weekend Plan',
        'description': 'Planning for the weekend? Consider booking a ride to the Airport on Saturday.',
        'icon': Icons.weekend,
      },
      {
        'title': 'Carpool Opportunity',
        'description': 'Save money by sharing your ride with others going to Business District.',
        'icon': Icons.people,
      },
      {
        'title': 'Frequent Destination',
        'description': 'Quick booking to Shopping Mall, one of your frequent destinations.',
        'icon': Icons.shopping_bag,
      },
    ];
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Header
        Text(
          'Recommendations for You',
          style: AppTextStyles.headingMedium,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Based on your ride history and preferences',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textColorLight,
          ),
        ),
        const SizedBox(height: 24.0),
        
        // Recommendations
        ...mockRecommendations.map((rec) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RecommendationCard(
            title: rec['title'] as String,
            description: rec['description'] as String,
            icon: rec['icon'] as IconData,
            onTap: () {
              _chatbotBloc.add(SendMessageEvent(
                message: 'Tell me more about ${rec['title']}',
                userId: userId,
              ));
              Navigator.pushNamed(context, AppRoutes.chat);
            },
          ),
        )).toList(),
        
        // Bottom spacing
        const SizedBox(height: 16.0),
      ],
    );
  }
}
