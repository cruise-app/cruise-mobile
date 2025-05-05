import 'package:cruise/features/carpooling/data/models/create_trip_request.dart';
import 'package:cruise/features/carpooling/domain/usecases/create_trip_usecase.dart';
import 'package:cruise/features/carpooling/domain/usecases/place_suggestion_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_trip_event.dart';
part 'create_trip_state.dart';

class CreateTripBloc extends Bloc<CreateTripEvent, CreateTripState> {
  PlaceSuggestionUsecase placeSuggestionUsecase = PlaceSuggestionUsecase();
  CreateTripUsecase createTripUsecase = CreateTripUsecase();
  CreateTripBloc() : super(CreateTripInitialState()) {
    on<CreateTripSubmitted>((event, emit) async {
      print("Now in the bloc ${event.driverID}");
      print("Now in the bloc ${event.departureTime}");
      print("Now in the bloc ${event.startLocationName}");
      print("Now in the bloc ${event.endLocationName}");
      print("Now in the bloc ${event.vehicleType}");
      // handle trip creation
      if (event.driverID.isEmpty) {
        emit(CreateTripErrorState("Session expired"));
      }
      if (event.startLocationName.isEmpty) {
        emit(CreateTripErrorState("Please select a start location"));
      }
      if (event.endLocationName.isEmpty) {
        emit(CreateTripErrorState("Please select an end location"));
      }
      if (event.departureTime.isEmpty) {
        emit(CreateTripErrorState("Please select a departure time"));
      }
      if (event.vehicleType.isEmpty) {
        emit(CreateTripErrorState("Please select a vehicle type"));
      }

      await createTripUsecase
          .createTrip(CreateTripRequest(
        driverID: event.driverID,
        startLocationName: event.startLocationName,
        endLocationName: event.endLocationName,
        departureTime: event.departureTime,
        vehicleType: event.vehicleType,
      ))
          .then((response) {
        response.fold(
          (failure) => emit(CreateTripErrorState(failure.message)),
          (trip) => emit(CreateTripSuccessState()),
        );
      });
      //emit(CreateTripSuccessState());
    });

    on<SearchingLocation>((event, emit) async {
      print("Now in the bloc ${event.location}");
      // handle location searchs
      if (event.location.isEmpty) return;
      if (event.location.isNotEmpty) {
        await placeSuggestionUsecase
            .getPlaceSuggestions(event.location)
            .then((response) {
          response.fold(
            (failure) => emit(CreateTripSuccessState()),
            (suggestions) => emit(LocationSearchingState(suggestions)),
          );
        });
      }
    });
  }
}
