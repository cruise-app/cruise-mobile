import 'package:cruise/features/login/data/models/login_request.dart';
import 'package:cruise/features/login/data/models/login_response.dart';
import 'package:cruise/features/login/data/services/login_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class LoginRepo {
  final LoginService loginService;

  LoginRepo() : loginService = LoginService();

  Future<Either<Failure, LoginResponse>> loginUser(LoginRequest request) async {
    return await loginService.loginUser(request.toJson());
  }
}
