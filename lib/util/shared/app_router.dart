import 'package:cruise/presentation/create_password/create_password_screen.dart';
import 'package:cruise/presentation/email_verification_code/email_verification_code_screen.dart';
import 'package:cruise/presentation/forget_password/forget_password_screen.dart';
import 'package:cruise/presentation/lobby/lobby_screen.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/register/register_screen.dart';
import '../../presentation/login/login_screen.dart';

abstract class AppRouter {
  static const kLobbyScreen = '/';
  static const kRegisterScreen = '/RegisterScreen';
  static const kLoginScreen = '/LoginScreen';
  static const kForgetPasswordScreen = '/ForgetPasswordScreen';
  static const kEmailVerificationCodeScreen = '/EmailVerificationCodeScreen';
  static const kCreatePasswordScreen = '/CreatePasswordScreen';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: kLobbyScreen,
        builder: (context, state) => const LobbyScreen(),
      ),
      GoRoute(
        path: kRegisterScreen,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: kLoginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: kForgetPasswordScreen,
        builder: (context, state) => const ForgetPasswordScreen(),
      ),
      GoRoute(
        path: kEmailVerificationCodeScreen,
        builder: (context, state) => const EmailVerificationCodeScreen(),
      ),
      GoRoute(
        path: kCreatePasswordScreen,
        builder: (context, state) => const CreatePasswordScreen(),
      )
    ],
  );
}
