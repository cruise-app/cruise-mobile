import 'package:cruise/util/shared/api_service.dart';

class RegisterService {
  final ApiService _apiService;

  RegisterService(this._apiService);

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: 'register',
        data: requestData,
      );

      return response;
    } catch (e) {
      throw Exception("Failed to register user: $e");
    }
  }
}
