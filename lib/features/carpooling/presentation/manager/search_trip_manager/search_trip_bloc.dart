import 'package:cruise/features/carpooling/data/models/search_trips_request.dart';
import 'package:cruise/features/carpooling/data/models/trip_model.dart';
import 'package:cruise/features/carpooling/domain/usecases/place_suggestion_usecase.dart';
import 'package:cruise/features/carpooling/domain/usecases/search_trip_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'search_trip_event.dart';
part 'search_trip_state.dart';

class SearchTripBloc extends Bloc<SearchTripEvent, SearchTripState> {
  final PlaceSuggestionUsecase placeSuggestionUsecase =
      PlaceSuggestionUsecase();
  final SearchTripUsecase searchTripUsecase = SearchTripUsecase();
  SearchTripBloc() : super(SearchTripInitialState()) {
    on<SearchingLocation>((event, emit) async {
      print("Now in the bloc ${event.location}");
      // handle location searchs
      if (event.location.isEmpty) return;
      if (event.location.isNotEmpty) {
        await placeSuggestionUsecase
            .getPlaceSuggestions(event.location)
            .then((response) {
          response.fold(
            (failure) => emit(SearchTripFailure()),
            (suggestions) => emit(LocationSearchingState(suggestions)),
          );
        });
      }
    });

    on<ClearSuggestions>((event, emit) {
      // handle clearing suggestions
      emit(LocationSearchingState([]));
    });

    on<GetTrips>((event, emit) async {
      // handle getting trips
      emit(SearchTripLoadingState());
      print(
          "Fetching trips from ${event.startLocation} to ${event.endLocation}");

      if (event.startLocation.isEmpty || event.endLocation.isEmpty) {
        emit(SearchTripFailure(
            message: "Please provide both start and end locations."));
        return;
      }
      print(event.startLocation);
      print(event.endLocation);
      // Mock data for demonstration purposes
      final result = await searchTripUsecase.getSearchTrips(SearchTripsRequest(
        userId: event.userId,
        departureLocation: event.startLocation,
        destinationLocation: event.endLocation,
        departureDate: event.dateTime,
        maxDistance: 1500,
      ));

      result.fold((failure) {
        emit(
          SearchTripFailure(message: failure.message),
        );
      },
          (trips) => {
                emit(
                  GetTripsSuccess(
                    trips: trips.trips,
                  ),
                ),
              });
    });
  }
}
