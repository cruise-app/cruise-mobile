import 'package:cruise/presentation/register/data/models/register_request.dart';
import 'package:cruise/presentation/register/data/models/register_response.dart';
import 'package:cruise/presentation/register/domain/repo/register_repo.dart';

class RegisterUsecase {
  final RegisterRepo repository;

  RegisterUsecase(this.repository);

  Future<RegisterResponse> call(RegisterRequest request) async {
    return await repository.register(request);
  }
}
