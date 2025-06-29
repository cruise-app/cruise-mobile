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
import 'package:cruise/features/rental/presentation/views/car_listing_screen.dart';
import 'package:cruise/features/rental/presentation/views/location_selection_screen.dart';
import 'package:cruise/features/rental/data/models/booking_range.dart';

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
  static const kCarListingScreen = '/CarListingScreen';
  static const kLocationSelectionScreen = '/LocationSelectionScreen';

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
        path: kCarListingScreen,
        builder: (context, state) => CarListingScreen(),
      ),
      GoRoute(
        path: kCarBookingScreen,
        builder: (context, state) => const CarBookingScreen(),
      ),
      GoRoute(
        path: kCarDetailsScreen,
        builder: (context, state) {
          CarModel? car;
          int days = 1;
          String? locationStr;
          BookingRange? range;
          if (state.extra is Map) {
            final Map map = state.extra as Map;
            car = map['car'] as CarModel?;
            days = map['days'] as int? ?? 1;
            locationStr = map['location'] as String?;
            if (map.containsKey('range')) {
              final r = map['range'] as Map;
              range = BookingRange(
                start: DateTime.parse(r['start']),
                end: DateTime.parse(r['end']),
              );
            }
          } else if (state.extra is CarModel) {
            car = state.extra as CarModel;
          }
          return CarDetailsScreen(
            car: car ??
                const CarModel(
                    plateNumber: '',
                    name: 'Unknown',
                    category: '',
                    imagePath: '',
                    pricePerDay: 0,
                    totalPrice: 0,
                    transmission: ''),
            bookingDays: days,
            selectedRange: range,
            selectedLocation: locationStr,
          );
        },
      ),
      GoRoute(
        path: kLocationSelectionScreen,
        builder: (context, state) => const LocationSelectionScreen(),
      ),
    ],
  );
}
