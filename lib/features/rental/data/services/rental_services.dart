import 'package:cruise/util/shared/api_service.dart';
import 'package:dartz/dartz.dart';
import 'package:cruise/util/shared/failure_model.dart';
import '../models/car_model.dart';

class RentalService {
  final ApiService _apiService = ApiService();

  // Fetch available cars list
  Future<Either<Failure, List<CarModel>>> getAvailableCars(
      Map<String, dynamic> query) async {
    try {
      final response = await _apiService.get(
        endPoint: 'api/rentals/getCars', // Remove leading slash
        data: query,
      );
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      // Check if the response indicates success
      if (response.statusCode != 200) {
        return Left(Failure(
            message: response.statusMessage ?? 'Failed to retrieve cars'));
      }

      // Handle different response structures
      List<dynamic> carsData;
      if (response.data is Map<String, dynamic>) {
        // If response has a 'data' field
        if (response.data.containsKey('data')) {
          carsData = response.data['data'] as List<dynamic>;
        }
        // If response has a 'cars' field
        else if (response.data.containsKey('cars')) {
          carsData = response.data['cars'] as List<dynamic>;
        }
        // If the entire response.data is the cars array
        else {
          return Left(Failure(message: 'Unexpected response format'));
        }
      }
      // If response.data is directly an array
      else if (response.data is List) {
        carsData = response.data as List<dynamic>;
      } else {
        return Left(Failure(message: 'Invalid response format'));
      }

      print("Cars data length: ${carsData.length}");

      final cars = carsData
          .map((e) => CarModel.fromJson(e as Map<String, dynamic>))
          .toList();

      print("Parsed cars count: ${cars.length}");
      return Right(cars);
    } catch (e) {
      print("Error in getAvailableCars: $e");
      return Left(Failure(message: "Failed to fetch cars: ${e.toString()}"));
    }
  }

  // Reserve a car
  Future<Either<Failure, Map<String, dynamic>>> reserveCar({
    required String carId,
    required String renterId,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, num> pickupLocation,
  }) async {
    try {
      final response = await _apiService.post(endPoint: '/api/rentals', data: {
        'carId': carId,
        'renterId': renterId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'pickupLocation': pickupLocation,
      });
      return Right(Map<String, dynamic>.from(response.data));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getReservations(
      String plateNumber) async {
    try {
      final response = await _apiService.get(
          endPoint: '/api/rentals/$plateNumber/reservations');
      final list = List<Map<String, dynamic>>.from(response.data);
      return Right(list);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
