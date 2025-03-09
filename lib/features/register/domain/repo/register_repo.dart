import 'package:cruise/features/register/data/models/register_request.dart';
import 'package:cruise/features/register/data/models/register_response.dart';
import 'package:cruise/features/register/data/services/register_service.dart';
import 'package:dio/dio.dart';

class RegisterRepo {
  final RegisterService registerService;

  RegisterRepo() : registerService = RegisterService();

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      print("The JSON now looks like this: ${request.toJson()}");
      final response = await registerService.registerUser(request.toJson());
      return RegisterResponse.fromJson(response);
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
