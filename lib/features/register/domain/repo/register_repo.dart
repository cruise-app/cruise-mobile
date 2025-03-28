import 'package:cruise/features/register/data/models/register_request.dart';
import 'package:cruise/features/register/data/models/register_response.dart';
import 'package:cruise/features/register/data/services/register_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class RegisterRepo {
  final RegisterService registerService;

  RegisterRepo() : registerService = RegisterService();

  Future<Either<Failure, RegisterResponse>> register(
      RegisterRequest request) async {
    try {
      print("The JSON now looks like this: ${request.toJson()}");

      final responseEither =
          await registerService.registerUser(request.toJson());

      return responseEither.fold(
        (failure) {
          print("Registration failed: ${failure.message}");
          return Left(Failure(message: failure.message));
        },
        (responseData) {
          if (responseData.isEmpty) {
            return Left(Failure(message: "Empty response from server"));
          }
          try {
            final registerResponse = RegisterResponse.fromJson(responseData);
            return Right(registerResponse);
          } catch (e) {
            return Left(Failure(message: "Failed to parse response"));
          }
        },
      );
    } catch (e) {
      return Left(Failure(message: "Unexpected error: $e"));
    }
  }
}
