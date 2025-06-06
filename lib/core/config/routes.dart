import 'package:flutter/material.dart';
import '../../features/chatbot/presentation/views/dashboard_screen.dart';
import '../../features/chatbot/presentation/views/chatbot_screen.dart';
import '../../features/chatbot/presentation/views/recommendation_screen.dart';
import '../../features/chatbot/presentation/views/carpool_screen.dart';
import '../../features/chatbot/presentation/views/safety_check_screen.dart';

class AppRoutes {
  AppRoutes._(); // Private constructor to prevent instantiation

  // Route names
  static const String dashboard = '/';
  static const String chat = '/chat';
  static const String recommendations = '/recommendations';
  static const String carpool = '/carpool';
  static const String safetyCheck = '/safety-check';

  // Route generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );

      case chat:
        return MaterialPageRoute(
          builder: (_) => const ChatbotScreen(),
          settings: settings,
        );

      case recommendations:
        return MaterialPageRoute(
          builder: (_) => const RecommendationScreen(),
          settings: settings,
        );

      case carpool:
        return MaterialPageRoute(
          builder: (_) => const CarpoolScreen(),
          settings: settings,
        );

      case safetyCheck:
        return MaterialPageRoute(
          builder: (_) => const SafetyCheckScreen(),
          settings: settings,
        );

      default:
        // If there is no such named route, navigate to the dashboard
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
    }
  }
}
