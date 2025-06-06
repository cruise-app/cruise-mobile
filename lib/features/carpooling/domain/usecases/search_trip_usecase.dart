import 'package:cruise/features/carpooling/data/models/search_trip_response.dart';
import 'package:cruise/features/carpooling/data/models/search_trips_request.dart';
import 'package:cruise/features/carpooling/data/models/trip_model.dart';
import 'package:cruise/features/carpooling/data/services/carpooling_services.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class SearchTripUsecase {
  final CarpoolingService _createTripService;

  SearchTripUsecase() : _createTripService = CarpoolingService();

  Future<Either<Failure, SearchTripResponse>> getSearchTrips(
      SearchTripsRequest query) async {
    final response = await _createTripService.searchTrips(query.toJson());
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data),
    );
  }
}
