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

final class EmailVerificationStateSuccess extends RegisterState {}

final class PhoneVerificationStateSuccess extends RegisterState {}

final class EmailVerificationStateFailure extends RegisterState {
  final String message;

  EmailVerificationStateFailure(this.message);
}

final class PhoneVerificationStateFailure extends RegisterState {
  final String message;

  PhoneVerificationStateFailure(this.message);
}
