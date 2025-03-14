import 'package:cruise/features/register/data/models/verify_otp.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:cruise/features/register/data/models/check_email.dart';
import 'package:cruise/features/register/data/models/check_phone.dart';
import 'package:cruise/util/shared/api_service.dart';

class RegisterService {
  final ApiService _apiService;

  RegisterService() : _apiService = ApiService();

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: 'register',
        data: requestData,
      );
      return response;
    } on DioException catch (e) {
      return {'error': _handleDioError(e, "Failed to register user")};
    }
  }

  Future<Either<Failure, CheckEmailResponse>> checkEmail(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: 'check-email',
        data: requestData,
      );
      final CheckEmailResponse emailOtpResponse =
          CheckEmailResponse.fromJson(response);
      print("Good part {}");
      return Right(emailOtpResponse);
    } on DioException catch (e) {
      print("Serice Error part {}");
      print("Error: $e");
      return Left(ValidationFailure(message: "Failed to verify email"));
    }
  }

  Future<Either<Failure, CheckPhoneResponse>> checkPhone(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: 'check-phoneNumber',
        data: requestData,
      );
      final checkPhoneRequest = CheckPhoneResponse.fromJson(response);
      return Right(checkPhoneRequest);
    } on DioException catch (e) {
      return left(
          ValidationFailure(message: e.message ?? 'Failed to verify phone'));
      //throw Exception(_handleDioError(e, "Failed to verify phone"));
    }
  }

  Future<Either<Failure, CheckEmailResponse>> sendEmailOtp(
      Map<String, dynamic> requestData) async {
    try {
      final response =
          await _apiService.post(endPoint: 'send-email-otp', data: requestData);

      final checkEmailResponse = CheckEmailResponse.fromJson(response);

      return Right(checkEmailResponse); // Success case
    } catch (e) {
      return Left(Failure(message: e.toString())); // Failure case
    }
  }

  Future<Either<Failure, CheckPhoneResponse>> sendPhoneOtp(
      Map<String, dynamic> requestData) async {
    try {
      final response =
          await _apiService.post(endPoint: 'send-sms-otp', data: requestData);

      final checkPhoneResponse = CheckPhoneResponse.fromJson(response);

      return Right(checkPhoneResponse); // Success case
    } catch (e) {
      return Left(Failure(message: e.toString())); // Failure case
    }
  }

  Future<Either<Failure, VerifyOtpResponse>> verifyOtp(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: 'verify-otp',
        data: requestData,
      );
      final verifyOtpResponse = VerifyOtpResponse.fromJson(response);
      print("Good part {}");
      return Right(verifyOtpResponse);
    } on DioException catch (e) {
      print("Serice Error part {}");
      print("Error: $e");
      return Left(ValidationFailure(message: "Failed to verify email"));
    }
  }

  String _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null) {
      return "${e.response?.statusCode}: ${e.response?.data['message'] ?? defaultMessage}";
    }
    return defaultMessage;
  }
}
