import 'package:cruise/features/register/data/models/register_request.dart';
import 'package:cruise/features/register/data/models/register_response.dart';
import 'package:cruise/features/register/domain/repo/register_repo.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class RegisterUsecase {
  final RegisterRepo repository;

  RegisterUsecase() : repository = RegisterRepo();

  Future<Either<Failure, RegisterResponse>> call(
      RegisterRequest request) async {
    try {
      final responseEither = await repository.register(request);

      return responseEither.fold(
        (failure) {
          print("Registration failed: ${failure.message}");
          return Left(Failure(message: failure.message));
        },
        (registerResponse) {
          return Right(registerResponse);
        },
      );
    } catch (e) {
      return Left(Failure(message: "Unexpected error: $e"));
    }
  }
}
