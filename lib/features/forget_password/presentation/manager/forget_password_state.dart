part of 'forget_password_bloc.dart';

sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

final class ForgetPasswordLoadingState extends ForgetPasswordState {}

final class ForgetPasswordSuccessState extends ForgetPasswordState {
  final String message;

  ForgetPasswordSuccessState({required this.message});
}

final class ForgetPasswordFailureState extends ForgetPasswordState {
  final String message;

  ForgetPasswordFailureState({required this.message});
}
