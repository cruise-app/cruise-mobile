import 'package:cruise/util/shared/api_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class CreateTripService {
  final ApiService _apiService;
  final String _preUrl = 'carpooling/';

  CreateTripService() : _apiService = ApiService();

  Future<Either<Failure, Map<String, dynamic>>> createTrip(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}create-trip',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getSuggestions(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}get-suggested-locations',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
