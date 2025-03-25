import 'package:cruise/features/forget_password/data/models/create_password_request.dart';
import 'package:cruise/features/forget_password/data/models/create_password_response.dart';
import 'package:cruise/features/forget_password/data/models/verify_email_request.dart';
import 'package:cruise/features/forget_password/data/models/verify_email_response.dart';
import 'package:cruise/features/forget_password/data/services/forget_password_service.dart';
import 'package:cruise/features/register/data/models/verify_otp.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class ForgetPasswordUsecase {
  final ForgetPasswordService forgetPasswordService;

  ForgetPasswordUsecase() : forgetPasswordService = ForgetPasswordService();

  Future<Either<Failure, VerifyEmailResponse>> verifyEmail(
      VerifyEmailRequest request) async {
    print("The json now looks like this : ${request.toJson()}");
    return await forgetPasswordService.verifyEmail(request.toJson());
  }

  Future<Either<Failure, VerifyOtpResponse>> verifyOtp(
      VerifyOtpRequest request) async {
    return await forgetPasswordService.verifyOtp(request.toJson());
  }

  Future<Either<Failure, CreatePasswordResponse>> createPassword(
      CreatePasswordRequest request) async {
    return await forgetPasswordService.resetPassword(request.toJson());
  }
}
