import 'package:cruise/features/forget_password/data/models/create_password_response.dart';
import 'package:cruise/features/forget_password/data/models/verify_email_response.dart';
import 'package:cruise/features/register/data/models/verify_otp.dart';
import 'package:cruise/util/shared/api_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ForgetPasswordService {
  final ApiService _apiService;
  final String _preUrl = 'forget-password/';
  ForgetPasswordService() : _apiService = ApiService();

  Future<Either<Failure, VerifyEmailResponse>> verifyEmail(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}verify-email',
        data: requestData,
      );
      return Right(VerifyEmailResponse.fromJson(response));
    } on DioException catch (e) {
      return Left(Failure(message: e.message ?? 'Failed to verify email'));
    }
  }

  Future<Either<Failure, VerifyOtpResponse>> verifyOtp(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}verify-otp',
        data: requestData,
      );
      return Right(VerifyOtpResponse.fromJson(response));
    } on DioException catch (e) {
      return Left(Failure(message: e.message ?? 'Failed to verify otp'));
    }
  }

  Future<Either<Failure, CreatePasswordResponse>> resetPassword(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}create-new-password',
        data: requestData,
      );
      return Right(CreatePasswordResponse.fromJson(response));
    } on DioException catch (e) {
      return Left(Failure(message: e.message ?? 'Failed to reset password'));
    }
  }
}
