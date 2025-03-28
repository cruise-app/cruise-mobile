import 'package:cruise/features/login/data/models/user_model.dart';

class LoginResponse {
  final String token;
  final String message;
  final UserModel user;
  final bool success;

  LoginResponse({
    required this.token,
    required this.message,
    required this.user,
    required this.success,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      message: json['message'],
      user: UserModel.fromJson(json['user']),
      success: json['success'],
    );
  }
}
