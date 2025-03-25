import 'package:cruise/features/forget_password/presentation/views/forget_password_flow.dart';
import 'package:cruise/features/forget_password/presentation/views/forget_step_three.dart';
import 'package:cruise/features/forget_password/presentation/manager/forget_password_bloc.dart';
import 'package:cruise/features/forget_password/presentation/views/forget_step_two.dart';
import 'package:cruise/features/forget_password/presentation/views/forget_step_one.dart';
import 'package:cruise/features/lobby/lobby_screen.dart';
import 'package:cruise/features/login/presentation/manager/login_bloc.dart';

import 'package:cruise/features/register/presentation/manager/register_bloc.dart';

import 'package:cruise/features/register/presentation/views/register_flow_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/login/presentation/views/login_screen.dart';

abstract class AppRouter {
  static const kLobbyScreen = '/';
  static const kRegisterFlow = '/RegisterFlow';
  static const kEmailVerificationScreen = '/RegisterVerificationScreen';
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
            child: ForgetPasswordFlow()),
      ),
    ],
  );
}
