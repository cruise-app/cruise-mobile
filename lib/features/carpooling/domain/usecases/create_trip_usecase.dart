import 'package:cruise/features/carpooling/data/models/create_trip_request.dart';
import 'package:cruise/features/carpooling/data/models/create_trip_response.dart';
import 'package:cruise/features/carpooling/data/services/carpooling_services.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class CreateTripUsecase {
  final CarpoolingService _carpoolingService;
  CreateTripUsecase() : _carpoolingService = CarpoolingService();

  Future<Either<Failure, CreateTripResponse>> createTrip(
      CreateTripRequest requestData) async {
    final response = await _carpoolingService.createTrip(requestData.toJson());
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data),
    );
  }
}
