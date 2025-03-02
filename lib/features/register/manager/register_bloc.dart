import 'package:bloc/bloc.dart';
import 'package:cruise/presentation/register/data/models/register_request.dart';
import 'package:cruise/presentation/register/domain/usecases/register_usecase.dart';
import 'package:meta/meta.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;
  RegisterBloc(this.registerUsecase) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    print('Iam now in the bloc');
    try {
      final response = await registerUsecase(RegisterRequest(
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
      ));
      emit(RegisterSuccess(response.message)); // Success response
    } catch (e) {
      emit(RegisterFailure(e.toString())); // Error handling
    }
  }
}
