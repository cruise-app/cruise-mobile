import 'package:bloc/bloc.dart';
import 'package:cruise/features/carpooling/data/services/carpooling_services.dart';
import 'package:cruise/features/carpooling/data/services/carpooling_sockets.dart';

part 'join_trip_event.dart';
part 'join_trip_state.dart';

class JoinTripBloc extends Bloc<JoinTripEvent, JoinTripState> {
  final CarpoolingService _carpoolingService;
  final SocketService _socketService;

  JoinTripBloc()
      : _carpoolingService = CarpoolingService(),
        _socketService = SocketService(),
        super(JoinTripInitial()) {
    on<JoinTripRequested>(_onJoinTripRequested);
  }

  Future<void> _onJoinTripRequested(
    JoinTripRequested event,
    Emitter<JoinTripState> emit,
  ) async {
    try {
      emit(JoinTripLoading());

      final result = await _carpoolingService.joinTrip(
        tripId: event.tripId,
        passengerId: event.passengerId,
        username: event.username,
        passengerPickup: event.passengerPickup,
        passengerDropoff: event.passengerDropoff,
      );

      result.fold(
        (failure) => emit(JoinTripFailure(message: failure.message)),
        (data) {
          // Notify socket about the join
          _socketService.emitEvent('tripJoined', {
            'tripId': event.tripId,
            'passengerId': event.passengerId,
          });

          emit(JoinTripSuccess(data: data));
        },
      );
    } catch (e) {
      emit(JoinTripFailure(message: e.toString()));
    }
  }
}
