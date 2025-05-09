import 'package:cruise/features/carpooling/data/models/get_polyline_request.dart';
import 'package:cruise/features/carpooling/data/models/get_polyline_response.dart';
import 'package:cruise/features/carpooling/data/services/carpooling_services.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class GetTripRouteUsecase {
  final CarpoolingService _carpoolingService;

  GetTripRouteUsecase() : _carpoolingService = CarpoolingService();

  Future<Either<Failure, GetPolylineResponse>> getTripRoute(
      GetPolylineRequest requestData) async {
    final response =
        await _carpoolingService.getTripRoute(requestData.toJson());
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data),
    );
  }
}
