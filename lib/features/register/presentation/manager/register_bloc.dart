import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cruise/features/register/data/models/check_email.dart';
import 'package:cruise/features/register/data/models/check_phone.dart';
import 'package:cruise/features/register/data/models/register_request.dart';
import 'package:cruise/features/register/data/models/verify_otp.dart';
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
    on<RegisterStepOneSubmitted>(_validateRegisterStepOne);
    on<RegisterStepTwoSubmitted>(_validateRegisterStepTwo);
    on<ToVerifySubmitted>(_validateEmailOtp);
    // on<RegisterSubmitted>(_onRegisterUser);
    // on<EmailVerificationSubmitted>(_onEmailVerification);
    // on<PhoneVerificationSubmitted>(_onPhoneVerification);
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
  }

  // Future<void> _onEmailVerification(
  //     EmailVerificationSubmitted event, Emitter<RegisterState> emit) async {
  //   try {
  //     final response = await verificationUsecase
  //         .emailVerification(EmailOtpRequest(email: event.email));
  //     print(response.status);
  //     // response.status == "success"
  //     //     ? emit(PhoneVerificationState())
  //     //     : emit(RegisterFailureState('Failed to verify email'));
  //   } catch (e) {
  //     emit(RegisterFailureState("Email verification error: $e"));
  //   }
  // }

  // Future<void> _onPhoneVerification(
  //     PhoneVerificationSubmitted event, Emitter<RegisterState> emit) async {
  //   try {
  //     final response = await verificationUsecase
  //         .phoneVerification(PhoneOtpRequest(phoneNumber: event.phoneNumber));
  //     print(response.status);

  //     if (response.status == "success") {
  //       if (_registerRequest == null) {
  //         emit(RegisterFailureState(
  //             "Error: Registration request data is missing"));
  //         return;
  //       }

  //       emit(RegisterLoadingState());

  //       try {
  //         final registerResponse = await registerUsecase(_registerRequest!);
  //         emit(RegisterSuccessState(registerResponse.message));
  //       } catch (e) {
  //         emit(RegisterFailureState("Registration failed: $e"));
  //       }
  //     } else {
  //       emit(RegisterFailureState('Failed to verify phone'));
  //     }
  //   } catch (e) {
  //     emit(RegisterFailureState("Phone verification error: $e"));
  //   }
  // }

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
    print("Im in step 2");

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
      (failure) {
        // Handle different failure types (assuming Failure has a message field)
        emit(RegisterStepTwoStateFailure(failure.message));
      },
      (success) {
        // Emit success state
        print(success.status);
        verificationUsecase.sendEmailOTP(CheckEmailRequest(email: event.email));
        emit(RegisterStepTwoStateSuccess());
      },
    );
  }

  Future<void> _validateEmailOtp(
      ToVerifySubmitted event, Emitter<RegisterState> emit) async {
    final response = await verificationUsecase.verifyEmail(
        VerifyOtpRequest(toVerify: event.toVerify, otp: event.otp));

    response.fold(
      (failure) {
        // Handle different failure types (assuming Failure has a message field)
        emit(EmailVerificationStateFailure(failure.message));
      },
      (success) {
        // Emit success state
        print(success.status);
        emit(EmailVerificationStateSuccess());
      },
    );
  }
}
