import 'package:cruise/features/login/data/models/login_response.dart';
import 'package:cruise/util/shared/api_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class LoginService {
  final ApiService _apiService;
  final String _preUrl = 'login/';

  LoginService() : _apiService = ApiService();

  Future<Either<Failure, LoginResponse>> loginUser(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}login',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(LoginResponse.fromJson(response.data));
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
