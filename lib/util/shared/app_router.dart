import 'package:cruise/features/carpooling/presentation/manager/search_trip_manager/search_trip_bloc.dart';
import 'package:cruise/features/carpooling/presentation/views/carpooling_search_screen.dart';
import 'package:cruise/features/chatbot/presentation/views/chatbot_screen.dart';
import 'package:cruise/features/forget_password/presentation/views/forget_password_flow.dart';
import 'package:cruise/features/forget_password/presentation/manager/forget_password_bloc.dart';
import 'package:cruise/features/lobby/lobby_screen.dart';
import 'package:cruise/features/login/presentation/manager/login_bloc.dart';
import 'package:cruise/features/register/presentation/manager/register_bloc.dart';
import 'package:cruise/features/register/presentation/views/register_flow_screen.dart';
import 'package:cruise/features/splash_screen/splash_screen.dart';
import 'package:cruise/util/shared/widgets/bottom_navigation_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cruise/features/login/presentation/views/login_screen.dart';
import 'package:cruise/features/rental/presentation/views/car_booking_screen.dart';
import 'package:cruise/features/rental/presentation/views/car_details_screen.dart';
import 'package:cruise/features/rental/data/models/car_model.dart';

abstract class AppRouter {
  static const kLobbyScreen = '/LobbyScreen';
  static const kRegisterFlow = '/RegisterFlow';
  static const kEmailVerificationScreen = '/RegisterVerificationScreen';
  static const kLoginScreen = '/LoginScreen';
  static const kForgetPasswordScreen = '/ForgetPasswordScreen';
  static const kEmailVerificationCodeScreen = '/EmailVerificationCodeScreen';
  static const kCreatePasswordScreen = '/CreatePasswordScreen';
  static const kBottomNavigationScreen = '/BottomNavigationScreen';
  static const kSplashScreen = '/';
  static const kCarpoolingSearchScreen = '/CarpoolingSearchScreen';
  static const kChatBotScreen = '/ChatBotScreen';
  static const kCarBookingScreen = '/CarBookingScreen';
  static const kCarDetailsScreen = '/CarDetailsScreen';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: kSplashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: kLobbyScreen,
        builder: (context, state) => const LobbyScreen(),
      ),
      GoRoute(
        path: kRegisterFlow,
        builder: (context, state) => BlocProvider(
          create: (context) => RegisterBloc(),
          child: const RegisterFlowScreen(),
        ),
      ),
      GoRoute(
        path: kLoginScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: kForgetPasswordScreen,
        builder: (context, state) => BlocProvider(
            create: (context) => ForgetPasswordBloc(),
            child: const ForgetPasswordFlow()),
      ),
      GoRoute(
        path: kBottomNavigationScreen,
        builder: (context, state) => const BottomNavigationScreen(),
      ),
      GoRoute(
        path: kCarpoolingSearchScreen,
        builder: (context, state) => BlocProvider(
            create: (context) => SearchTripBloc(),
            child: const CarpoolingSearchScreen()),
      ),
      GoRoute(
        path: kChatBotScreen,
        builder: (context, state) => const ChatbotScreen(),
      ),
      GoRoute(
        path: kCarBookingScreen,
        builder: (context, state) => const CarBookingScreen(),
      ),
      GoRoute(
        path: kCarDetailsScreen,
        builder: (context, state) {
          final car = state.extra as CarModel;
          return CarDetailsScreen(car: car);
        },
      )
    ],
  );
}
