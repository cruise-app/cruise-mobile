import 'package:bloc/bloc.dart';
import 'package:cruise/features/carpooling/data/models/trip_model.dart';
import 'package:cruise/features/carpooling/data/services/carpooling_sockets.dart';

part 'carpool_screen_event.dart';
part 'carpool_screen_state.dart';

class CarpoolScreenBloc extends Bloc<CarpoolScreenEvent, CarpoolScreenState> {
  final SocketService socketService = SocketService();
  void Function(dynamic data)? _upcomingTripsListener;

  CarpoolScreenBloc() : super(CarpoolScreenInitial()) {
    on<FetchUpcomingTrips>(_fetchUpComingTrips);
    on<UpcomingTripsReceived>(_onUpcomingTripsReceived);
    on<DeleteUpcomingTrip>(_onDeleteUpcomingTrip);
    on<LeaveUpcomingTrip>(_onLeaveUpcomingTrip);
  }

  Future<void> _onLeaveUpcomingTrip(
      LeaveUpcomingTrip event, Emitter<CarpoolScreenState> emit) async {
    emit(CarpoolScreenLoading());

    socketService.connect();

    socketService.emitEvent('leaveUpcomingTrip', [event.userId, event.tripId]);
  }

  Future<void> _onDeleteUpcomingTrip(
      DeleteUpcomingTrip event, Emitter<CarpoolScreenState> emit) async {
    emit(CarpoolScreenLoading());

    // Connect if not already connected
    socketService.connect();

    // Emit the delete event to the backend
    socketService.emitEvent('deleteUpComingTrip', [event.userId, event.tripId]);
    // The backend will respond with "upComingTrips", which is already handled by your listener
  }

  Future<void> _fetchUpComingTrips(
      FetchUpcomingTrips event, Emitter<CarpoolScreenState> emit) async {
    emit(CarpoolScreenLoading());

    socketService.connect();

    // Remove any previous listener to avoid duplication
    if (_upcomingTripsListener != null) {
      socketService.offEvent('upComingTrips', _upcomingTripsListener!);
    }

    // Create a new listener
    _upcomingTripsListener = (data) {
      if (!isClosed) {
        add(UpcomingTripsReceived(data: data));
      }
    };

    // Attach the listener BEFORE emitting the event
    socketService.onEvent('upComingTrips', _upcomingTripsListener!);

    // Emit only after socket is connected
    if (socketService.socket.connected) {
      socketService.emitEvent('getUpComingTrips', event.userId);
    } else {
      // Wait for connection, then emit
      void onConnect(_) {
        socketService.emitEvent('getUpComingTrips', event.userId);
        socketService.socket.off('connect', onConnect);
      }

      socketService.socket.on('connect', onConnect);
    }
  }

  void _onUpcomingTripsReceived(
      UpcomingTripsReceived event, Emitter<CarpoolScreenState> emit) {
    final data = event.data;

    if (data['success']) {
      // List<Trip> trips = (data['data'] as List)
      //     .map((tripData) => Trip.fromJson(tripData))
      //     .toList();
      List<Trip> trips = (data['data'] as List)
          .map((tripData) => Trip.fromJson(tripData))
          .toList();
      print("Upcoming trips: $trips");
      emit(UpcomingTripsLoaded(trips));
    } else {
      emit(CarpoolScreenError(
        message: data['message'] ?? 'Error fetching trips',
      ));
    }
  }

  @override
  Future<void> close() {
    // Clean up the listener
    if (_upcomingTripsListener != null) {
      socketService.offEvent('upComingTrips', _upcomingTripsListener!);
    }
    return super.close();
  }
}
