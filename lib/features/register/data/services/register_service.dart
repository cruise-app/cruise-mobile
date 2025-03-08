import 'package:cruise/features/register/data/models/email_otp_model.dart';
import 'package:cruise/features/register/data/models/phone_otp_model.dart';
import 'package:cruise/util/shared/api_service.dart';

class RegisterService {
  final ApiService _apiService;

  RegisterService(this._apiService);

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: 'register',
        data: requestData,
      );

      return response;
    } catch (e) {
      throw Exception("Failed to register user: $e");
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
    } catch (e) {
      throw Exception("Failed to verify email: $e");
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
    } catch (e) {
      throw Exception("Failed to verify phone: $e");
    }
  }
}
