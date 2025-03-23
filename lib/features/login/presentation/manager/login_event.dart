part of 'login_bloc.dart';

sealed class LoginEvent {}

final class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}
