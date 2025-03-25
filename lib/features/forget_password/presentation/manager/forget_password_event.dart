part of 'forget_password_bloc.dart';

sealed class ForgetPasswordEvent {}

final class EmailSubmitted extends ForgetPasswordEvent {
  final String email;

  EmailSubmitted({required this.email});
}

final class VerificationCodeSubmitted extends ForgetPasswordEvent {
  final String email;
  final String otp;

  VerificationCodeSubmitted({required this.email, required this.otp});
}

final class NewPasswordSubmitted extends ForgetPasswordEvent {
  final String confirmPassword;
  final String password;
  final String email;

  NewPasswordSubmitted(
      {required this.email,
      required this.confirmPassword,
      required this.password});
}
