import 'package:cruise/features/login/data/models/login_request.dart';
import 'package:cruise/features/login/domain/usecases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc()
      : loginUsecase = LoginUsecase(),
        super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async => await _loginUser(event, emit));
  }

  Future<void> _loginUser(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    print('Hello iam in the login bloc');
    try {
      emit(LoginLoadingState());
      final RegExp emailRegex = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(LoginFailureState(message: 'Please fill in all fields.'));
        return;
      } else if (!emailRegex.hasMatch(event.email)) {
        emit(LoginFailureState(message: 'Invalid email address.'));
        return;
      }
      print('Hello iam in the login bloc');
      final response = await loginUsecase.call(
        LoginRequest(
          email: event.email,
          password: event.password,
        ),
      );
      await response.fold(
          (failure) async => emit(
                LoginFailureState(
                  message: failure.message,
                ),
              ), (success) async {
        // Get the token from the response and save it in Hive
        print(success.token);
        print(success.user);
        print(success.user.id);
        print(success.user.userName);
        print(success.user.email);
        var box = Hive.box('userBox');
        await box.put('token', success.token);
        await box.put('userModel', success.user);

        emit(
          LoginSuccessState(
            message: success.message,
          ),
        );
      });
    } catch (e) {
      emit(LoginFailureState(
          message: 'Something went wrong. Please try again.'));
    }
  }
}
