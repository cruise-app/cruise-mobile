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
