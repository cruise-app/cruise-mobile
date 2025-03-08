import 'package:cruise/features/register/data/models/email_otp_model.dart';
import 'package:cruise/features/register/data/models/phone_otp_model.dart';
import 'package:cruise/features/register/data/services/register_service.dart';

class VerificationUsecase {
  final RegisterService registerService; // fix

  VerificationUsecase(this.registerService);

  Future<PhoneOtpResponse> phoneVerification(PhoneOtpRequest request) async {
    try {
      print("The json now looks like this : ${request.toJson()}");
      return await registerService.requestPhoneOTP(request.toJson());
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  Future<EmailOtpResponse> emailVerification(EmailOtpRequest request) async {
    try {
      print("The json now looks like this : ${request.toJson()}");
      return await registerService.requestEmailOTP(request.toJson());
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }
}
