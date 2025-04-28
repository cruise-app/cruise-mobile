import 'package:cruise/features/carpooling/domain/usecases/place_suggestion_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_trip_event.dart';
part 'create_trip_state.dart';

class CreateTripBloc extends Bloc<CreateTripEvent, CreateTripState> {
  PlaceSuggestionUsecase placeSuggestionUsecase = PlaceSuggestionUsecase();
  CreateTripBloc() : super(CreateTripInitialState()) {
    on<CreateTripSubmitted>((event, emit) {
      // handle trip submission
      emit(CreateTripSuccessState());
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
