import 'package:cruise/features/carpooling/data/models/create_trip_request.dart';
import 'package:cruise/features/carpooling/data/models/get_polyline_request.dart';
import 'package:cruise/features/carpooling/domain/usecases/create_trip_usecase.dart';
import 'package:cruise/features/carpooling/domain/usecases/get_trip_route_usecase.dart';
import 'package:cruise/features/carpooling/domain/usecases/place_suggestion_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'create_trip_event.dart';
part 'create_trip_state.dart';

class CreateTripBloc extends Bloc<CreateTripEvent, CreateTripState> {
  PlaceSuggestionUsecase placeSuggestionUsecase = PlaceSuggestionUsecase();
  CreateTripUsecase createTripUsecase = CreateTripUsecase();
  GetTripRouteUsecase getTripRouteUsecase = GetTripRouteUsecase();
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

    on<FetchPolylineForReview>((event, emit) async {
      print("Now in the bloc ${event.startLocationName}");
      print("Now in the bloc ${event.endLocationName}");
      // handle location searchs
      if (event.startLocationName.isEmpty && event.endLocationName.isEmpty) {
        emit(PolylineErrorState("Please select a start & end locations"));
        return;
      }
      if (event.startLocationName.isEmpty) {
        emit(PolylineErrorState("Please select a start location"));
        return;
      }
      if (event.endLocationName.isEmpty) {
        emit(PolylineErrorState("Please select an end location"));
        return;
      }

      await getTripRouteUsecase
          .getTripRoute(GetPolylineRequest(
              startLocationName: event.startLocationName,
              endLocationName: event.endLocationName))
          .then((response) {
        response.fold((failure) => emit(PolylineErrorState(failure.message)),
            (polyline) {
          print(polyline);
          print("I got this now ${polyline.polyline}");
          print("I got this now ${polyline.startLocation}");
          print("I got this now ${polyline.endLocation}");
          emit(PolylineForReviewState(
              polyline: polyline.polyline ?? const <LatLng>[],
              startLocation: polyline.startLocation ?? const LatLng(0, 0),
              endLocation: polyline.endLocation ?? const LatLng(0, 0)));
        });
      });
    });
  }
}
