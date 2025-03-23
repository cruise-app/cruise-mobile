import 'package:cruise/features/login/data/models/login_response.dart';
import 'package:cruise/util/shared/api_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LoginService {
  final ApiService _apiService;
  final String _preUrl = 'login/';

  LoginService() : _apiService = ApiService();

  Future<Either<Failure, LoginResponse>> loginUser(
      Map<String, dynamic> requestData) async {
    try {
      print(requestData);
      print("hello");
      final response = await _apiService.post(
        endPoint: '${_preUrl}login',
        data: requestData,
      );
      final loginResponse = LoginResponse.fromJson(response);
      // print("hello tani");
      print(Right(loginResponse));
      return Right(loginResponse);
    } on DioException catch (e) {
      return Left(Failure(message: e.message ?? 'Failed to login'));
    }
  }
}
