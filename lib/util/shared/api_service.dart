import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: "http://192.168.56.1:3000/"));

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    try {
      print("GET: ${_dio.options.baseUrl}$endPoint");
      final response = await _dio.get(endPoint);
      return response.data;
    } catch (e) {
      print("GET request error: $e");
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      print("POST: ${_dio.options.baseUrl}$endPoint");
      print("Payload: $data");
      final response = await _dio.post(endPoint, data: data);
      return response.data;
    } catch (e) {
      print("POST request error: $e");
      return {'error': e.toString()};
    }
  }
}
