import 'package:cruise/features/login/data/models/login_request.dart';
import 'package:cruise/features/login/data/models/login_response.dart';
import 'package:cruise/features/login/domain/repo/login_repo.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LoginUsecase {
  final LoginRepo repository;

  LoginUsecase() : repository = LoginRepo();

  Future<Either<Failure, LoginResponse>> call(LoginRequest request) async {
    try {
      return await repository.loginUser(request);
    } on DioException catch (e) {
      return Left(Failure(message: e.message ?? 'Failed to login'));
    } catch (e) {
      return Left(Failure(message: 'Something went wrong. Please try again.'));
    }
  }
}
