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
  final VerificationUsecase verificationUsercase;
  RegisterRequest? _registerRequest;

  RegisterBloc(this.registerUsecase, this.verificationUsercase)
      : super(RegisterInitial()) {
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

    emit(EmailVerficationState());
  }

  FutureOr<void> _onEmailVerification(
      EmailVerificationSubmitted event, Emitter<RegisterState> emit) async {
    final response = await verificationUsercase
        .emailVerification(EmailOtpRequest(email: event.email));
    print(response.status);
    response.status == "success"
        ? emit(PhoneVerificationState())
        : emit(RegisterFailureState('Failed to verify email'));
  }

  FutureOr<void> _onPhoneVerification(
      PhoneVerificationSubmitted event, Emitter<RegisterState> emit) async {
    final response = await verificationUsercase
        .phoneVerification(PhoneOtpRequest(phoneNumber: event.phoneNumber));
    print(response.status);
    if (response.status == "success") {
      emit(RegisterLoadingState());
      try {
        final response = await registerUsecase(_registerRequest!);
        emit(RegisterSuccessState(response.message)); // Success response
      } catch (e) {
        emit(RegisterFailureState(e.toString())); // Error handling
      }
    } else {
      emit(RegisterFailureState('Failed to verify phone'));
    }
  }
}
