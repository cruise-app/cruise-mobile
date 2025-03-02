import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  final baseUrl = "http://192.168.56.1:3000/";

  ApiService(this._dio);

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    print(baseUrl + endPoint);
    var response = await _dio.get('$baseUrl$endPoint');
    return response.data;
  }

  Future<Map<String, dynamic>> post(
      {required String endPoint, required Map<String, dynamic> data}) async {
    print(baseUrl + endPoint);
    print('I am in API Service');
    print(data);
    var response = await _dio.post('$baseUrl$endPoint', data: data);

    return response.data;
  }
}
