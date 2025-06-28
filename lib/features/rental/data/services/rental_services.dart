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
        endPoint: '/api/rentals',
        data: query,
      );
      final data = response.data as List<dynamic>;
      final cars = data.map((e) => CarModel.fromJson(e)).toList();
      return Right(cars);
    } catch (e) {
      return Left(Failure(message: e.toString()));
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

  Future<Either<Failure, List<Map<String, dynamic>>>> getReservations(String plateNumber) async {
    try {
      final response = await _apiService.get(endPoint: '/api/rentals/$plateNumber/reservations');
      final list = List<Map<String, dynamic>>.from(response.data);
      return Right(list);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
} 