import 'package:cruise/features/carpooling/data/services/create_trip_service.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class PlaceSuggestionUsecase {
  final CreateTripService _createTripService;

  PlaceSuggestionUsecase() : _createTripService = CreateTripService();

  Future<Either<Failure, List<String>>> getPlaceSuggestions(
      String query) async {
    final response = await _createTripService.getSuggestions({'input': query});
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(List<String>.from(data['data'] ?? [])),
    );
  }
}
