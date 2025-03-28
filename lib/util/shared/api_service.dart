import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: "http://192.168.56.1:3000/",
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              validateStatus: (status) =>
                  true, // Allows handling all status codes manually
            )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("Request: ${options.method} ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("Response: ${response.statusCode} ${response.data}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("Dio Error: ${e.response?.statusCode} ${e.response?.data}");
        handler.resolve(Response(
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode ?? 500,
          data: handleDioError(e),
        ));
      },
    ));
  }

  // Handles different HTTP errors
  Map<String, dynamic> handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode ?? 0;
      final message = e.response!.data?['message'] ?? "Something went wrong";

      switch (statusCode) {
        case 400:
          return {"message": "Bad Request"};
        case 401:
          return {"message": "Unauthorized. Please check your credentials."};
        case 403:
          return {"message": "Forbidden. You don't have permission."};
        case 404:
          return {
            "message": "Not Found. The requested resource doesn't exist."
          };
        case 500:
          return {"message": "Server error. Please try again later."};
        default:
          return {"message": message};
      }
    } else {
      return {"message": "No internet connection. Please check your network."};
    }
  }

  Future<Response> post({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      print("POST: ${_dio.options.baseUrl}$endPoint");
      print("Payload: $data");
      final response = await _dio.post(endPoint, data: data);
      return response;
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: Response(
          requestOptions: e.requestOptions,
          statusCode: 500,
          data: handleDioError(e),
        ),
      );
    }
  }
}
