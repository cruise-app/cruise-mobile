import 'package:cruise/presentation/register/data/models/register_request.dart';
import 'package:cruise/presentation/register/data/models/register_response.dart';
import 'package:cruise/presentation/register/data/services/register_service.dart';

class RegisterRepo {
  final RegisterService registerService;

  RegisterRepo(this.registerService);

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      print("The json now looks like this : ${request.toJson()}");
      final response = await registerService.registerUser(request.toJson());
      return RegisterResponse.fromJson(response);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }
}
