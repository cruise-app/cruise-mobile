import 'package:cruise/features/create_password/create_password_screen.dart';
import 'package:cruise/features/email_verification_code/email_verification_code_screen.dart';
import 'package:cruise/features/forget_password/forget_password_screen.dart';
import 'package:cruise/features/lobby/lobby_screen.dart';

import 'package:cruise/features/register/presentation/manager/register_bloc.dart';
import 'package:cruise/features/register/presentation/views/phone_verification_screen.dart';
import 'package:cruise/features/register/presentation/views/register_flow_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/login/login_screen.dart';

abstract class AppRouter {
  static const kLobbyScreen = '/';
  static const kRegisterFlow = '/RegisterFlow';
  static const kRegisterScreen = '/RegisterScreen';
  static const kEmailVerificationScreen = '/RegisterVerificationScreen';
  static const kPhoneVerificationScreen = '/PhoneVerificationScreen';
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
        path: kRegisterFlow,
        builder: (context, state) => BlocProvider(
          create: (context) => RegisterBloc(),
          child: RegisterFlowScreen(),
        ),
      ),
      GoRoute(
        path: kPhoneVerificationScreen,
        builder: (context, state) => const PhoneVerificationScreen(),
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
      ),
    ],
  );
}
