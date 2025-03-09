part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}

final class RegisterSuccessState extends RegisterState {
  final String message;

  RegisterSuccessState(this.message);
}

final class RegisterFailureState extends RegisterState {
  final String message;

  RegisterFailureState(this.message);
}

final class EmailVerificationState extends RegisterState {}

final class PhoneVerificationState extends RegisterState {}
