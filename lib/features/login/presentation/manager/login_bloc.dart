import 'package:cruise/features/login/data/models/login_request.dart';
import 'package:cruise/features/login/domain/usecases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc()
      : loginUsecase = LoginUsecase(),
        super(LoginInitial()) {
    on<LoginSubmitted>(_loginUser);
  }

  Future<void> _loginUser(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    print('Hello iam in the login bloc');
    try {
      emit(LoginLoadingState());
      print('Hello iam in the login bloc');
      final response = await loginUsecase.call(
        LoginRequest(
          email: event.email,
          password: event.password,
        ),
      );
      response.fold(
        (failure) => emit(
          LoginFailureState(
            message: failure.message,
          ),
        ),
        (success) => emit(
          LoginSuccessState(
            message: success.message,
          ),
        ),
      );
    } catch (e) {
      emit(LoginFailureState(
          message: 'Something went wrong. Please try again.'));
    }
  }
}
