import 'package:cruise/features/forget_password/data/models/create_password_request.dart';
import 'package:cruise/features/forget_password/data/models/verify_email_request.dart';
import 'package:cruise/features/forget_password/domain/usecases/forget_password_usecase.dart';
import 'package:cruise/features/register/data/models/verify_otp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final ForgetPasswordUsecase _forgetPasswordUsecase;

  ForgetPasswordBloc()
      : _forgetPasswordUsecase = ForgetPasswordUsecase(),
        super(ForgetPasswordInitial()) {
    on<EmailSubmitted>(_verifyEmail);
    on<VerificationCodeSubmitted>(_verifyCode);
    on<NewPasswordSubmitted>(_createPassword);
  }

  Future<void> _verifyEmail(
      EmailSubmitted event, Emitter<ForgetPasswordState> emit) async {
    emit(ForgetPasswordLoadingState());
    if (event.email.isEmpty) {
      emit(ForgetPasswordFailureState(message: 'Email cannot be empty'));
      return;
    }
    final response = await _forgetPasswordUsecase
        .verifyEmail(VerifyEmailRequest(email: event.email));

    response.fold(
      (failure) => emit(ForgetPasswordFailureState(message: failure.message)),
      (success) {
        print("success");
        emit(ForgetPasswordSuccessState(message: 'Email verified'));
      },
    );
  }

  Future<void> _verifyCode(VerificationCodeSubmitted event,
      Emitter<ForgetPasswordState> emit) async {
    print("event.email: ${event.email}");
    emit(ForgetPasswordLoadingState());
    if (event.otp.isEmpty) {
      emit(ForgetPasswordFailureState(message: 'Code cannot be empty'));
      return;
    }
    final response = await _forgetPasswordUsecase
        .verifyOtp(VerifyOtpRequest(toVerify: event.email, otp: event.otp));

    response.fold(
      (failure) => emit(ForgetPasswordFailureState(message: failure.message)),
      (success) {
        print("success");
        emit(ForgetPasswordSuccessState(message: 'Code verified'));
      },
    );
  }

  Future<void> _createPassword(
      NewPasswordSubmitted event, Emitter<ForgetPasswordState> emit) async {
    emit(ForgetPasswordLoadingState());
    if (event.password.isEmpty) {
      emit(ForgetPasswordFailureState(message: 'Password cannot be empty'));
      return;
    }
    if (event.confirmPassword.isEmpty) {
      emit(ForgetPasswordFailureState(
          message: 'Confirm password cannot be empty'));
      return;
    }
    if (event.password != event.confirmPassword) {
      emit(ForgetPasswordFailureState(
          message: 'Password and confirm password do not match'));
      return;
    }
    final response = await _forgetPasswordUsecase.createPassword(
        CreatePasswordRequest(
            email: event.email,
            password: event.password,
            confirmPassword: event.confirmPassword));

    response.fold(
      (failure) => emit(ForgetPasswordFailureState(message: failure.message)),
      (success) {
        print("success");
        emit(ForgetPasswordSuccessState(message: 'Password created'));
      },
    );
  }
}
