import 'package:cruise/features/register/data/models/register_request.dart';
import 'package:cruise/features/register/data/models/register_response.dart';
import 'package:cruise/features/register/domain/repo/register_repo.dart';
import 'package:dio/dio.dart';

class RegisterUsecase {
  final RegisterRepo repository;

  RegisterUsecase() : repository = RegisterRepo();

  Future<RegisterResponse> call(RegisterRequest request) async {
    try {
      return await repository.register(request);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return "Error ${e.response?.statusCode}: ${e.response?.data['message'] ?? 'Something went wrong'}";
    }
    return "Network error: ${e.message}";
  }
}
