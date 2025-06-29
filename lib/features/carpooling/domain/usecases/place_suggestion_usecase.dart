import 'package:cruise/features/carpooling/data/services/carpooling_services.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';

class PlaceSuggestionUsecase {
  final CarpoolingService _createTripService;

  PlaceSuggestionUsecase() : _createTripService = CarpoolingService();

  Future<Either<Failure, List<String>>> getPlaceSuggestions(
      String query) async {
    print("I am querying");
    final response = await _createTripService.getSuggestions({'input': query});
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(List<String>.from(data['data'] ?? [])),
    );
  }
}
