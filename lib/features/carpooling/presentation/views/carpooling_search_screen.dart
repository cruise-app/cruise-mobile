import 'package:cruise/features/carpooling/data/models/trip_model.dart';
import 'package:cruise/features/carpooling/presentation/manager/search_trip_manager/search_trip_bloc.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/carpool_trip_detail.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/search_location_box.dart';
import 'package:cruise/features/login/data/models/user_model.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cruise/features/carpooling/presentation/manager/join_trip_manager/join_trip_bloc.dart';

class CarpoolingSearchScreen extends StatefulWidget {
  const CarpoolingSearchScreen({super.key});

  @override
  State<CarpoolingSearchScreen> createState() => _CarpoolingSearchScreenState();
}

class _CarpoolingSearchScreenState extends State<CarpoolingSearchScreen> {
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();
  final FocusNode startLocationFocusNode = FocusNode();
  final FocusNode endLocationFocusNode = FocusNode();
  String? activeField;
  List<String> suggestions = [];
  Timer? _debounce;
  DateTime? selectedDateTimeFromChild;
  UserModel? user;
  String? token;
  late JoinTripBloc _joinTripBloc;

  @override
  void initState() {
    super.initState();
    _joinTripBloc = JoinTripBloc();
    // Access the extra parameter in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      if (extra != null) {
        setState(() {
          user = extra['user'];
          token = extra['token'];
        });
      }
    });
  }

  @override
  void dispose() {
    startLocationController.dispose();
    endLocationController.dispose();
    startLocationFocusNode.dispose();
    endLocationFocusNode.dispose();
    _debounce?.cancel();
    _joinTripBloc.close();
    super.dispose();
  }

  void textFieldLogic(String value, String field) {
    setState(() {
      suggestions.clear();
    });
    if (field == 'startLocation') {
      startLocationController.text = value;
    } else if (field == 'endLocation') {
      endLocationController.text = value;
    }
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        context.read<SearchTripBloc>().add(
              SearchingLocation(location: value),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.black,
        iconTheme: const IconThemeData(color: MyColors.lightYellow),
        title: Text(
          'Find a Ride',
          style: theme.textTheme.titleLarge?.copyWith(
            color: MyColors.lightYellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: (startLocationController.text.isNotEmpty &&
                endLocationController.text.isNotEmpty)
            ? () {
                print("controller ${startLocationController.text}");
                print("User ID: ${user?.id}");
                context.read<SearchTripBloc>().add(
                      GetTrips(
                        userId: user!.id,
                        startLocation: startLocationController.text,
                        endLocation: endLocationController.text,
                        dateTime: selectedDateTimeFromChild,
                        maxDistance: 100,
                      ),
                    );
              }
            : null,
        backgroundColor: MyColors.lightGrey,
        child: const Icon(Icons.search, color: MyColors.lightYellow),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Box Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [MyColors.black.withOpacity(0.6), MyColors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: SearchLocationBox(
                    selectedDateTimeFromChild: (dateTime) {
                      setState(() {
                        selectedDateTimeFromChild = dateTime;
                      });
                      print('Selected DateTime: $dateTime');
                    },
                    startLocationController: startLocationController,
                    endLocationController: endLocationController,
                    startLocationFocusNode: startLocationFocusNode,
                    endLocationFocusNode: endLocationFocusNode,
                    onStartLocationChanged: (value) {
                      setState(() {
                        activeField = 'startLocation';
                      });
                      textFieldLogic(value, 'startLocation');
                    },
                    onEndLocationChanged: (value) {
                      setState(() {
                        activeField = 'endLocation';
                      });
                      textFieldLogic(value, 'endLocation');
                    },
                    activeField: activeField,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Suggestions and Trips List
              Expanded(
                child: BlocBuilder<SearchTripBloc, SearchTripState>(
                  builder: (context, state) {
                    if (state is SearchTripLoadingState) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: MyColors.lightYellow,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Loading...',
                              style: TextStyle(color: MyColors.lightYellow),
                            ),
                          ],
                        ),
                      );
                    } else if (state is LocationSearchingState &&
                        state.suggestions.isNotEmpty) {
                      return Card(
                        color: MyColors.lightYellow,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedOpacity(
                            opacity: state.suggestions.isNotEmpty ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: ListView.separated(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: state.suggestions.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 1,
                                color: MyColors.lightGrey,
                              ),
                              itemBuilder: (context, index) {
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (activeField == 'startLocation') {
                                        startLocationController.text =
                                            state.suggestions[index];
                                        startLocationFocusNode.unfocus();
                                      } else if (activeField == 'endLocation') {
                                        endLocationController.text =
                                            state.suggestions[index];
                                        endLocationFocusNode.unfocus();
                                      }
                                      setState(() {
                                        suggestions.clear();
                                      });
                                      context
                                          .read<SearchTripBloc>()
                                          .add(ClearSuggestions());
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Text(
                                        state.suggestions[index],
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
                                          color: MyColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } else if (state is SearchTripFailure) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.redAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else if (state is GetTripsSuccess) {
                      print('Trips fetched: ${state.trips.length}');

                      if (state.trips.isEmpty) {
                        return const Center(
                          child: Text(
                            'No trips found for the selected route.',
                            style: TextStyle(
                              color: MyColors.lightYellow,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.trips.length,
                        itemBuilder: (context, index) {
                          final trip = state.trips[index];
                          return _buildTripCard(
                            context,
                            trip,
                            theme,
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard(
    BuildContext context,
    Trip trip,
    ThemeData theme,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColors.black.withOpacity(0.8), MyColors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            print('Tapped on trip: ${trip.id}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarpoolTripDetail(trip: trip),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Route
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: MyColors.lightYellow,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${trip.startLocationName} → ${trip.endLocationName}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: MyColors.lightYellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Vehicle and Seats
                Row(
                  children: [
                    const Icon(
                      Icons.directions_car,
                      color: MyColors.lightGrey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Vehicle: ${trip.vehicleType}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: MyColors.lightGrey,
                      ),
                    ),
                    const Spacer(),
                    if (trip.seatsAvailable != null)
                      Text(
                        'Seats: ${trip.seatsAvailable}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: MyColors.lightGrey,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // Departure Time and Estimated Duration
                if (trip.departureTime != null ||
                    trip.estimatedTripTime != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: MyColors.lightGrey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        trip.departureTime != null
                            ? 'Departs: ${DateFormat('MMM d, h:mm a').format(trip.departureTime!)}'
                            : 'Time: N/A',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: MyColors.lightGrey,
                        ),
                      ),
                      if (trip.estimatedTripTime != null) ...[
                        const SizedBox(width: 16),
                        Text(
                          'Duration: ${trip.estimatedTripTime}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: MyColors.lightGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                const SizedBox(height: 8),
                // Passengers
                if (trip.listOfPassengers.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        color: MyColors.lightGrey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Passengers: ${trip.listOfPassengers.map((p) => p.username).join(', ')}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: MyColors.lightGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                // Action Button
                Align(
                  alignment: Alignment.centerRight,
                  child: BlocConsumer<JoinTripBloc, JoinTripState>(
                    bloc: _joinTripBloc,
                    listener: (context, state) {
                      if (state is JoinTripSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Successfully joined ${trip.driverUsername}\'s trip!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarpoolTripDetail(
                              trip: trip,
                              joinedTrip: true,
                            ),
                          ),
                        );
                      } else if (state is JoinTripFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is JoinTripLoading) {
                        return const SizedBox(
                          height: 36,
                          width: 36,
                          child: CircularProgressIndicator(
                            color: MyColors.lightYellow,
                          ),
                        );
                      }

                      return ElevatedButton(
                        onPressed: () {
                          print('Joining trip: ${trip.id}');
                          print('User ID: ${user!.id}');
                          print('User Name: ${user!.userName}');
                          print('Trip ID: ${trip.id}');
                          print(
                              'Trip Start Location: ${trip.startLocationName}');
                          print('Trip End Location: ${trip.endLocationName}');
                          _joinTripBloc.add(
                            JoinTripRequested(
                              tripId: trip.id,
                              passengerId: user!.id,
                              username: user!.userName,
                              passengerPickup: trip.startLocationName,
                              passengerDropoff: trip.endLocationName,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.lightYellow,
                          foregroundColor: MyColors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Join Trip'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
