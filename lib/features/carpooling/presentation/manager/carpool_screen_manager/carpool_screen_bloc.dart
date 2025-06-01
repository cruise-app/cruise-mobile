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

    // Set the new listener
    socketService.onEvent('upComingTrips', _upcomingTripsListener!);

    socketService.emitEvent('getUpComingTrips', event.userId);
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
