import 'package:cruise/features/register/data/models/check_email.dart';
import 'package:cruise/features/register/data/models/check_phone.dart';
import 'package:cruise/features/register/data/models/verify_otp.dart';
import 'package:cruise/features/register/data/services/register_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class VerificationUsecase {
  final RegisterService registerService; // fix

  VerificationUsecase() : registerService = RegisterService();

  // Future<PhoneOtpResponse> phoneVerification(PhoneOtpRequest request) async {
  //   try {
  //     print("The json now looks like this : ${request.toJson()}");
  //     return await registerService.requestPhoneOTP(request.toJson());
  //   } catch (e) {
  //     throw Exception("Registration failed: $e");
  //   }
  // }

  Future<Either<Failure, CheckEmailResponse>> emailAvailabilityCheck(
      CheckEmailRequest request) async {
    print("The json now looks like this : ${request.toJson()}");
    return await registerService.checkEmail(request.toJson());
  }

  Future<void> sendEmailOTP(CheckEmailRequest request) async {
    await registerService.sendEmailOTP(request.toJson());
  }

  Future<Either<Failure, VerifyOtpResponse>> verifyEmail(
      VerifyOtpRequest request) async {
    return await registerService.verifyOtp(request.toJson());
  }
}
