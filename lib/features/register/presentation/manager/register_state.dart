part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}

final class RegisterSuccessState extends RegisterState {
  final String message;

  RegisterSuccessState(this.message);
}

final class RegisterFailureState extends RegisterState {
  final String message;

  RegisterFailureState(this.message);
}

final class RegisterStepOneStateSuccess extends RegisterState {}

final class RegisterStepTwoStateSuccess extends RegisterState {}

final class RegisterStepThreeStateSuccess extends RegisterState {}

final class RegisterStepOneStateFailure extends RegisterState {
  final String message;

  RegisterStepOneStateFailure(this.message);
}

final class RegisterStepTwoStateFailure extends RegisterState {
  final String message;

  RegisterStepTwoStateFailure(this.message);
}

final class RegisterStepThreeStateFailure extends RegisterState {
  final String message;

  RegisterStepThreeStateFailure(this.message);
}

final class OtpVerificationStateSuccess extends RegisterState {}

final class OtpVerificationStateFailure extends RegisterState {
  final String message;

  OtpVerificationStateFailure(this.message);
}

final class RegisterSuccess extends RegisterState {}

final class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure({required this.message});
}

final class RegisterLoading extends RegisterState {}
