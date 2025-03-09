import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cruise/features/register/data/models/email_otp_model.dart';
import 'package:cruise/features/register/data/models/phone_otp_model.dart';
import 'package:cruise/features/register/data/models/register_request.dart';
import 'package:cruise/features/register/domain/usecases/register_usecase.dart';
import 'package:cruise/features/register/domain/usecases/verification_usecase.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;
  final VerificationUsecase verificationUsecase;
  RegisterRequest? _registerRequest;

  RegisterBloc()
      : registerUsecase = RegisterUsecase(),
        verificationUsecase = VerificationUsecase(),
        super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterUser);
    on<EmailVerificationSubmitted>(_onEmailVerification);
    on<PhoneVerificationSubmitted>(_onPhoneVerification);
  }

  Future<void> _onRegisterUser(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    _registerRequest = RegisterRequest(
      firstName: event.firstName,
      lastName: event.lastName,
      password: event.password,
      confirmPassword: event.confirmPassword,
      email: event.email,
      phoneNumber: event.phoneNumber,
      gender: event.gender,
      month: event.month,
      day: event.day,
      year: event.year,
    );

    emit(EmailVerificationState());
  }

  Future<void> _onEmailVerification(
      EmailVerificationSubmitted event, Emitter<RegisterState> emit) async {
    try {
      final response = await verificationUsecase
          .emailVerification(EmailOtpRequest(email: event.email));
      print(response.status);
      response.status == "success"
          ? emit(PhoneVerificationState())
          : emit(RegisterFailureState('Failed to verify email'));
    } catch (e) {
      emit(RegisterFailureState("Email verification error: $e"));
    }
  }

  Future<void> _onPhoneVerification(
      PhoneVerificationSubmitted event, Emitter<RegisterState> emit) async {
    try {
      final response = await verificationUsecase
          .phoneVerification(PhoneOtpRequest(phoneNumber: event.phoneNumber));
      print(response.status);

      if (response.status == "success") {
        if (_registerRequest == null) {
          emit(RegisterFailureState(
              "Error: Registration request data is missing"));
          return;
        }

        emit(RegisterLoadingState());

        try {
          final registerResponse = await registerUsecase(_registerRequest!);
          emit(RegisterSuccessState(registerResponse.message));
        } catch (e) {
          emit(RegisterFailureState("Registration failed: $e"));
        }
      } else {
        emit(RegisterFailureState('Failed to verify phone'));
      }
    } catch (e) {
      emit(RegisterFailureState("Phone verification error: $e"));
    }
  }
}
