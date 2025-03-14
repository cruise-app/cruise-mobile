import 'package:cruise/features/register/data/models/check_email.dart';
import 'package:cruise/features/register/data/models/check_phone.dart';
import 'package:cruise/features/register/data/models/verify_otp.dart';
import 'package:cruise/features/register/data/services/register_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class VerificationUsecase {
  final RegisterService registerService; // fix

  VerificationUsecase() : registerService = RegisterService();

  Future<Either<Failure, CheckEmailResponse>> emailAvailabilityCheck(
      CheckEmailRequest request) async {
    print("The json now looks like this : ${request.toJson()}");
    return await registerService.checkEmail(request.toJson());
  }

  Future<Either<Failure, CheckPhoneResponse>> phoneAvailabilityCheck(
      CheckPhoneRequest request) async {
    print("The json now looks like this : ${request.toJson()}");
    return await registerService.checkPhone(request.toJson());
  }

  Future<void> sendEmailOtp(CheckEmailRequest request) async {
    await registerService.sendEmailOtp(request.toJson());
  }

  Future<void> sendPhoneOtp(CheckPhoneRequest request) async {
    await registerService.sendPhoneOtp(request.toJson());
  }

  Future<Either<Failure, VerifyOtpResponse>> verifyOtp(
      VerifyOtpRequest request) async {
    return await registerService.verifyOtp(request.toJson());
  }
}
