part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;
  final String email;
  final String phoneNumber;
  final String gender;
  final String month;
  final String day;
  final String year;

  RegisterSubmitted(
      {required this.firstName,
      required this.lastName,
      required this.password,
      required this.confirmPassword,
      required this.email,
      required this.phoneNumber,
      required this.gender,
      required this.month,
      required this.day,
      required this.year});
}

class RegisterStepOneSubmitted extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String gender;
  final String month;
  final String day;
  final String year;

  RegisterStepOneSubmitted(
      {required this.firstName,
      required this.lastName,
      required this.gender,
      required this.month,
      required this.day,
      required this.year});
}

class RegisterStepTwoSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;

  RegisterStepTwoSubmitted(
      {required this.email,
      required this.password,
      required this.confirmPassword});
}

// class VerifyEmailSubmitted extends RegisterEvent {
//   final String email;
//   final String otp;
//   VerifyEmailSubmitted({required this.email, required this.otp});
// }

class ToVerifySubmitted extends RegisterEvent {
  final String toVerify;
  final String otp;

  ToVerifySubmitted({required this.toVerify, required this.otp});
}

class RegisterStepThreeSubmitted extends RegisterEvent {
  final String phoneNumber;
  final String countryCode;
  RegisterStepThreeSubmitted(
      {required this.phoneNumber, required this.countryCode});
}

// class VerifyPhoneSubmitted extends RegisterEvent {
//   final String phoneNumber;

//   VerifyPhoneSubmitted({required this.phoneNumber});
// }
