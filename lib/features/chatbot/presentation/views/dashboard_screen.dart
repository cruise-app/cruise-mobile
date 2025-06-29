import 'package:flutter/material.dart';
import '../../../../core/config/routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Simulated user ID for development
  final String userId = 'user_1234';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dashboard',
                    style: AppTextStyles.headingLarge,
                  ),
                  const CircleAvatar(
                    backgroundColor: AppColors.secondaryColor,
                    radius: 22,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // User greeting
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: AppColors.textColorLight,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Zeyad Tamer',
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 32.0),

              // Chat with Cruise section
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      context,
                      title: 'Chat with\nCruise',
                      icon: Icons.chat_bubble_outline,
                      iconColor: AppColors.primaryColor,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.chat);
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildDashboardCard(
                      context,
                      title: 'Talk to\nCruise',
                      icon: Icons.mic_none_rounded,
                      iconColor: AppColors.primaryColor,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.chat);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Topics section
              Text(
                'Topics',
                style: AppTextStyles.headingSmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // Topic icons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularTopicButton(
                    icon: Icons.directions_car,
                    label: 'Ride Booking',
                    color: Colors.amber,
                    onTap: () {
                      final chatbotBloc = sl<ChatbotBloc>();
                      Navigator.pushNamed(context, AppRoutes.chat);
                      chatbotBloc.add(SendMessageEvent(
                        message: 'Book a ride',
                        userId: userId,
                      ));
                    },
                  ),
                  _buildCircularTopicButton(
                    icon: Icons.payments_outlined,
                    label: 'Payments',
                    color: Colors.green,
                    onTap: () {
                      final chatbotBloc = sl<ChatbotBloc>();
                      Navigator.pushNamed(context, AppRoutes.chat);
                      chatbotBloc.add(SendMessageEvent(
                        message: 'Payment options',
                        userId: userId,
                      ));
                    },
                  ),
                  _buildCircularTopicButton(
                    icon: Icons.directions_car_filled_outlined,
                    label: 'Car Rental',
                    color: Colors.orange,
                    onTap: () {
                      final chatbotBloc = sl<ChatbotBloc>();
                      Navigator.pushNamed(context, AppRoutes.chat);
                      chatbotBloc.add(SendMessageEvent(
                        message: 'I need to rent a car',
                        userId: userId,
                      ));
                    },
                  ),
                  _buildCircularTopicButton(
                    icon: Icons.business_center_outlined,
                    label: 'Business',
                    color: Colors.purple,
                    onTap: () {
                      final chatbotBloc = sl<ChatbotBloc>();
                      Navigator.pushNamed(context, AppRoutes.chat);
                      chatbotBloc.add(SendMessageEvent(
                        message: 'Business account options',
                        userId: userId,
                      ));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // History section
              Text(
                'History',
                style: AppTextStyles.headingSmall,
              ),
              const SizedBox(height: 16.0),

              // Chat history items
              Expanded(
                child: ListView(
                  children: [
                    _buildHistoryItem(
                      icon: Icons.location_on_outlined,
                      title: 'How do I change my drop-off location?',
                      subtitle: 'Today, 5:41 AM',
                      onTap: () {
                        final chatbotBloc = sl<ChatbotBloc>();
                        Navigator.pushNamed(context, AppRoutes.chat);
                        chatbotBloc.add(SendMessageEvent(
                          message: 'How do I change my drop-off location?',
                          userId: userId,
                        ));
                      },
                    ),
                    _buildHistoryItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'Can I rent a car for the weekend?',
                      subtitle: 'Yesterday',
                      onTap: () {
                        final chatbotBloc = sl<ChatbotBloc>();
                        Navigator.pushNamed(context, AppRoutes.chat);
                        chatbotBloc.add(SendMessageEvent(
                          message: 'Can I rent a car for the weekend?',
                          userId: userId,
                        ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16.0),
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
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.0,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularTopicButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.0,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.1),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppColors.backgroundDark,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textColorLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            label: 'Carpool',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat with Cruise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.chat);
          }
        },
      ),
    );
  }
}
