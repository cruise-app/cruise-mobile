import 'package:dio/dio.dart';
import 'package:cruise/features/register/data/models/email_otp_model.dart';
import 'package:cruise/features/register/data/models/phone_otp_model.dart';
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

  Future<EmailOtpResponse> requestEmailOTP(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: 'verify-email',
        data: requestData,
      );
      return EmailOtpResponse.fromJson(response);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, "Failed to verify email"));
    }
  }

  Future<PhoneOtpResponse> requestPhoneOTP(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: 'verify-phoneNumber',
        data: requestData,
      );
      return PhoneOtpResponse.fromJson(response);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, "Failed to verify phone"));
    }
  }

  String _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null) {
      return "${e.response?.statusCode}: ${e.response?.data['message'] ?? defaultMessage}";
    }
    return defaultMessage;
  }
}
