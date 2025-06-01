import 'package:cruise/features/carpooling/data/models/create_trip_response.dart';
import 'package:cruise/features/carpooling/data/models/get_polyline_response.dart';
import 'package:cruise/features/carpooling/data/models/search_trip_response.dart';
import 'package:cruise/features/carpooling/data/models/search_trips_request.dart';
import 'package:cruise/util/shared/api_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class CarpoolingService {
  final ApiService _apiService;
  final String _preUrl = 'carpooling/';

  CarpoolingService() : _apiService = ApiService();

  Future<Either<Failure, CreateTripResponse>> createTrip(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.post(
        endPoint: '${_preUrl}create-trip',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(CreateTripResponse.fromJson(response.data));
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

  Future<Either<Failure, GetPolylineResponse>> getTripRoute(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.get(
        endPoint: '${_preUrl}get-trip-route',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return Right(GetPolylineResponse.fromJson(response.data));
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<Either<Failure, SearchTripResponse>> searchTrips(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _apiService.get(
          endPoint: '${_preUrl}search-trips', data: requestData);

      if (response.statusCode == 200) {
        return Right(SearchTripResponse.fromJson(response.data));
      } else {
        return Left(Failure(message: response.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
