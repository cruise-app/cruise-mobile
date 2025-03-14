import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cruise/features/register/data/models/check_email.dart';
import 'package:cruise/features/register/data/models/check_phone.dart';
import 'package:cruise/features/register/data/models/register_request.dart';
import 'package:cruise/features/register/data/models/register_response.dart';
import 'package:cruise/features/register/data/models/verify_otp.dart';
import 'package:cruise/features/register/domain/usecases/register_usecase.dart';
import 'package:cruise/features/register/domain/usecases/verification_usecase.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;
  final VerificationUsecase verificationUsecase;

  late RegisterRequest _registerRequest;

  RegisterBloc()
      : registerUsecase = RegisterUsecase(),
        verificationUsecase = VerificationUsecase(),
        super(RegisterInitial()) {
    on<RegisterStepOneSubmitted>(_validateRegisterStepOne);
    on<RegisterStepTwoSubmitted>(_validateRegisterStepTwo);
    on<ToVerifySubmitted>(_validateOtp);
    on<RegisterStepThreeSubmitted>(_validateRegisterStepThree);
    on<RegisterSubmitted>(_registerUser);
  }

  Future<void> _registerUser(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    try {
      _registerRequest = RegisterRequest(
        firstName: event.firstName,
        lastName: event.lastName,
        password: event.password,
        email: event.email,
        phoneNumber: event.phoneNumber,
        gender: event.gender,
        month: event.month,
        day: event.day,
        year: event.year,
      );

      final response = await registerUsecase.call(_registerRequest);

      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  void _validateRegisterStepOne(
      RegisterStepOneSubmitted event, Emitter<RegisterState> emit) {
    if (event.firstName.isEmpty) {
      emit(RegisterStepOneStateFailure('First name is required'));
    } else if (event.lastName.isEmpty) {
      emit(RegisterStepOneStateFailure('Last name is required'));
    } else if (event.gender.isEmpty) {
      emit(RegisterStepOneStateFailure('Gender is required'));
    } else if (event.month.isEmpty) {
      emit(RegisterStepOneStateFailure('Month is required'));
    } else if (event.day.isEmpty) {
      emit(RegisterStepOneStateFailure('Day is required'));
    } else if (event.year.isEmpty) {
      emit(RegisterStepOneStateFailure('Year is required'));
    } else {
      emit(RegisterStepOneStateSuccess());
    }
  }

  Future<void> _validateRegisterStepTwo(
      RegisterStepTwoSubmitted event, Emitter<RegisterState> emit) async {
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (event.email.isEmpty) {
      emit(RegisterStepTwoStateFailure('Email is required'));
      return;
    } else if (event.password.isEmpty) {
      emit(RegisterStepTwoStateFailure('Password is required'));
      return;
    } else if (event.confirmPassword.isEmpty) {
      emit(RegisterStepTwoStateFailure('Confirm password is required'));
      return;
    } else if (event.password != event.confirmPassword) {
      emit(RegisterStepTwoStateFailure('Passwords do not match'));
      return;
    } else if (!emailRegex.hasMatch(event.email)) {
      emit(RegisterStepTwoStateFailure('Invalid email address'));
      return;
    }

    final response = await verificationUsecase
        .emailAvailabilityCheck(CheckEmailRequest(email: event.email));

    response.fold(
      (failure) => emit(RegisterStepTwoStateFailure(failure.message)),
      (success) {
        verificationUsecase.sendEmailOtp(CheckEmailRequest(email: event.email));
        emit(RegisterStepTwoStateSuccess());
      },
    );
  }

  Future<void> _validateOtp(
      ToVerifySubmitted event, Emitter<RegisterState> emit) async {
    final response = await verificationUsecase
        .verifyOtp(VerifyOtpRequest(toVerify: event.toVerify, otp: event.otp));

    response.fold(
      (failure) => emit(OtpVerificationStateFailure(failure.message)),
      (success) => emit(OtpVerificationStateSuccess()),
    );
  }

  Future<void> _validateRegisterStepThree(
      RegisterStepThreeSubmitted event, Emitter<RegisterState> emit) async {
    final RegExp phoneRegex = RegExp(r"^\+\d{1,4}[\s]?\d{6,14}$");

    if (event.phoneNumber.isEmpty) {
      emit(RegisterStepThreeStateFailure('Phone number is required'));
      return;
    } else if (event.countryCode.isEmpty) {
      emit(RegisterStepThreeStateFailure('Country code is required'));
      return;
    } else if (!phoneRegex.hasMatch(event.countryCode + event.phoneNumber)) {
      emit(RegisterStepThreeStateFailure('Invalid phone number'));
      return;
    }

    final response = await verificationUsecase.phoneAvailabilityCheck(
        CheckPhoneRequest(phoneNumber: event.countryCode + event.phoneNumber));

    response.fold(
      (failure) => emit(RegisterStepThreeStateFailure(failure.message)),
      (success) {
        verificationUsecase.sendPhoneOtp(CheckPhoneRequest(
            phoneNumber: event.countryCode + event.phoneNumber));
        emit(RegisterStepThreeStateSuccess());
      },
    );
  }
}
