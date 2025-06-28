import 'package:cruise/features/carpooling/data/services/carpooling_sockets.dart';
import 'package:cruise/features/carpooling/presentation/manager/carpool_screen_manager/carpool_screen_bloc.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/carpool_trip_detail.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/chat_screen.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/trip_session_screen.dart';
import 'package:cruise/features/login/data/models/user_model.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class UpcomingTripsWidget extends StatefulWidget {
  const UpcomingTripsWidget({super.key});

  @override
  State<UpcomingTripsWidget> createState() => _UpcomingTripsWidgetState();
}

class _UpcomingTripsWidgetState extends State<UpcomingTripsWidget> {
  late var box;
  UserModel? user;
  String? token;

  @override
  void initState() {
    super.initState();
    box = Hive.box('userBox');
    user = box.get('userModel');
    token = box.get('token');
    print("User ID: ${user!.id}");
    print("token: $token");
    context.read<CarpoolScreenBloc>().add(FetchUpcomingTrips(userId: user!.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Trips",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MyColors.lightYellow,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: BlocConsumer<CarpoolScreenBloc, CarpoolScreenState>(
            listener: (context, state) {
              if (state is CarpoolScreenError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is CarpoolScreenLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.lightYellow,
                  ),
                );
              } else if (state is CarpoolScreenError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is UpcomingTripsLoaded) {
                if (state.upcomingTrips.isEmpty) {
                  return const Center(
                    child: Text(
                      "No upcoming trips found.",
                      style: TextStyle(color: MyColors.lightGrey, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.upcomingTrips.length,
                  itemBuilder: (context, index) {
                    final trip = state.upcomingTrips[index];
                    final isCreator = trip.driverId == user!.id;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              MyColors.black.withOpacity(0.8),
                              MyColors.black
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarpoolTripDetail(
                                    trip: trip, joinedTrip: true),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: MyColors.lightYellow,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: MyColors.lightGrey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Driver: ${trip.driverUsername}',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: MyColors.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.directions_car,
                                      color: MyColors.lightGrey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${trip.vehicleType} · ${trip.seatsAvailable} seats',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: MyColors.lightGrey,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      DateFormat('MMM d, h:mm a')
                                          .format(trip.departureTime),
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: MyColors.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              tripId: trip.id,
                                              userId: user!.id,
                                              tripName:
                                                  '${trip.startLocationName} → ${trip.endLocationName}',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.chat_bubble_outline,
                                          color: MyColors.lightYellow),
                                      label: const Text(
                                        'Chat',
                                        style: TextStyle(
                                            color: MyColors.lightYellow),
                                      ),
                                    ),
                                    isCreator
                                        ? TextButton.icon(
                                            onPressed: () {
                                              final parentContext = context;
                                              showDialog(
                                                context: context,
                                                builder: (dialogContext) =>
                                                    AlertDialog(
                                                  backgroundColor:
                                                      MyColors.black,
                                                  title: const Text(
                                                    'Delete Trip',
                                                    style: TextStyle(
                                                        color: MyColors
                                                            .lightYellow),
                                                  ),
                                                  content: const Text(
                                                    'Are you sure you want to delete this trip?',
                                                    style: TextStyle(
                                                        color:
                                                            MyColors.lightGrey),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              dialogContext),
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .lightGrey),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        parentContext
                                                            .read<
                                                                CarpoolScreenBloc>()
                                                            .add(DeleteUpcomingTrip(
                                                                userId: trip
                                                                    .driverId,
                                                                tripId:
                                                                    trip.id));
                                                        Navigator.pop(
                                                            dialogContext);
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            label: const Text(
                                              'Delete Trip',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )
                                        : TextButton.icon(
                                            onPressed: () {
                                              final parentContext = context;
                                              showDialog(
                                                context: context,
                                                builder: (dialogContext) =>
                                                    AlertDialog(
                                                  backgroundColor:
                                                      MyColors.black,
                                                  title: const Text(
                                                    'Leave Trip',
                                                    style: TextStyle(
                                                        color: MyColors
                                                            .lightYellow),
                                                  ),
                                                  content: const Text(
                                                    'Are you sure you want to leave this trip?',
                                                    style: TextStyle(
                                                        color:
                                                            MyColors.lightGrey),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              dialogContext),
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .lightGrey),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        parentContext
                                                            .read<
                                                                CarpoolScreenBloc>()
                                                            .add(
                                                                LeaveUpcomingTrip(
                                                                    userId:
                                                                        user!
                                                                            .id,
                                                                    tripId: trip
                                                                        .id));
                                                        Navigator.pop(
                                                            dialogContext);
                                                      },
                                                      child: const Text(
                                                        'Leave',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.orange),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.exit_to_app,
                                                color: Colors.orange),
                                            label: const Text(
                                              'Leave Trip',
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                          ),
                                    // if (DateTime.now().isAfter(trip
                                    //         .departureTime
                                    //         .subtract(const Duration(
                                    //             minutes: 100))) &&
                                    //     DateTime.now().isBefore(trip
                                    //         .departureTime
                                    //         .add(const Duration(minutes: 30))))
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TripSessionScreen(
                                              trip: trip,
                                              currentUserId: user!.id,
                                              currentUserRole:
                                                  user!.id == trip.driverId
                                                      ? 'driver'
                                                      : 'user',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.directions,
                                          color: MyColors.black),
                                      label: const Text(
                                        'Start Trip',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: MyColors.black),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyColors.lightYellow,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
