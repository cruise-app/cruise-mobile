import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';
import '../widgets/carpool_card.dart';
import '../widgets/profile_avatar.dart';
import '../../domain/entities/message.dart';

class CarpoolScreen extends StatefulWidget {
  const CarpoolScreen({Key? key}) : super(key: key);

  @override
  State<CarpoolScreen> createState() => _CarpoolScreenState();
}

class _CarpoolScreenState extends State<CarpoolScreen> {
  // Simulated user ID for development
  final String userId = 'user_1234';
  late ChatbotBloc _chatbotBloc;
  
  @override
  void initState() {
    super.initState();
    _chatbotBloc = sl<ChatbotBloc>();
    _chatbotBloc.add(GetCarpoolOpportunitiesEvent(userId: userId));
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
                'Carpool Suggestions',
                style: AppTextStyles.headingSmall.copyWith(fontSize: 18.0),
              ),
            ],
          ),
        ),
        body: BlocBuilder<ChatbotBloc, ChatbotState>(
          builder: (context, state) {
            if (state is CarpoolOpportunitiesLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }
            
            if (state is CarpoolOpportunitiesLoaded) {
              return _buildCarpoolList(state.opportunities);
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
                      'Failed to load carpool opportunities',
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
                        _chatbotBloc.add(GetCarpoolOpportunitiesEvent(userId: userId));
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
  
  Widget _buildCarpoolList(List<Map<String, dynamic>> opportunities) {
    if (opportunities.isEmpty) {
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
              'No carpool opportunities available',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              'We couldn\'t find any carpool opportunities for your route.',
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
              child: const Text('Book a Regular Ride'),
            ),
          ],
        ),
      );
    }
    
    // Mock carpool data for UI
    final mockCarpools = [
      {
        'driver': 'John Doe',
        'pickup': 'Downtown Station',
        'dropoff': 'Airport Terminal 1',
        'time': DateTime.now().add(const Duration(hours: 2)),
        'seats': 2,
        'price': 15.0,
      },
      {
        'driver': 'Sarah Johnson',
        'pickup': 'Central Park',
        'dropoff': 'Business District',
        'time': DateTime.now().add(const Duration(hours: 3)),
        'seats': 3,
        'price': 12.0,
      },
      {
        'driver': 'Michael Smith',
        'pickup': 'University Campus',
        'dropoff': 'Shopping Mall',
        'time': DateTime.now().add(const Duration(hours: 1)),
        'seats': 1,
        'price': 10.0,
      },
    ];
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Header
        Text(
          'We found another user going your way',
          style: AppTextStyles.headingMedium.copyWith(fontSize: 22.0),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Want to split the ride?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textColorLight,
          ),
        ),
        const SizedBox(height: 24.0),
        
        // Carpools
        ...mockCarpools.map((carpool) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CarpoolCard(
            driverName: carpool['driver'] as String,
            pickupLocation: carpool['pickup'] as String,
            dropoffLocation: carpool['dropoff'] as String,
            time: carpool['time'] as DateTime,
            seats: carpool['seats'] as int,
            price: carpool['price'] as double,
            onJoin: () {
              _chatbotBloc.add(SendMessageEvent(
                message: 'I want to join the carpool with ${carpool['driver']}',
                userId: userId,
              ));
              Navigator.pushNamed(context, AppRoutes.chat);
            },
            onCancel: () {
              _chatbotBloc.add(SendMessageEvent(
                message: 'Show me other carpool options',
                userId: userId,
              ));
              Navigator.pushNamed(context, AppRoutes.chat);
            },
          ),
        )).toList(),
        
        // Bottom actions
        const SizedBox(height: 16.0),
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.chat);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text('No, Thanks'),
        ),
      ],
    );
  }
}
