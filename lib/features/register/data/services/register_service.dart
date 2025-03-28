import 'package:cruise/features/register/data/models/check_username.dart';
import 'package:cruise/features/register/data/models/verify_otp.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:cruise/features/register/data/models/check_email.dart';
import 'package:cruise/features/register/data/models/check_phone.dart';
import 'package:cruise/util/shared/api_service.dart';

class RegisterService {
  final ApiService _apiService;
  final String _preUrl = 'register/';
  RegisterService() : _apiService = ApiService();

  Future<Either<Failure, Map<String, dynamic>>> registerUser(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}register',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<Either<Failure, CheckEmailResponse>> checkEmail(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}check-email',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(CheckEmailResponse.fromJson(response.data));
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<Either<Failure, CheckPhoneResponse>> checkPhone(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}check-phoneNumber',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(CheckPhoneResponse.fromJson(response.data));
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<Either<Failure, CheckUsernameResponse>> checkUsername(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}check-username',
        data: requestData,
      );

      if (response.statusCode == 200) {
        final checkUsernameResponse =
            CheckUsernameResponse.fromJson(response.data);

        if (!checkUsernameResponse.success) {
          return Left(Failure(message: checkUsernameResponse.message));
        }

        return Right(checkUsernameResponse);
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<Either<Failure, CheckEmailResponse>> sendEmailOtp(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}send-email-otp',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(CheckEmailResponse.fromJson(response.data));
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<Either<Failure, CheckPhoneResponse>> sendPhoneOtp(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}send-sms-otp',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(CheckPhoneResponse.fromJson(response.data));
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<Either<Failure, VerifyOtpResponse>> verifyOtp(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}verify-otp',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(VerifyOtpResponse.fromJson(response.data));
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
