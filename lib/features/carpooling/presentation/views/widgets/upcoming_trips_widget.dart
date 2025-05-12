import 'package:cruise/features/carpooling/data/services/carpooling_sockets.dart';
import 'package:cruise/features/carpooling/presentation/manager/carpool_screen_manager/carpool_screen_bloc.dart';
import 'package:cruise/features/login/data/models/user_model.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class UpcomingTripsWidget extends StatefulWidget {
  const UpcomingTripsWidget({super.key});

  @override
  State<UpcomingTripsWidget> createState() => _UpcomingTripsWidgetState();
}

class _UpcomingTripsWidgetState extends State<UpcomingTripsWidget> {
  // ignore: prefer_typing_uninitialized_variables
  late var box;
  UserModel? user;
  String? token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    box = Hive.box('userBox');
    user = box.get('userModel');
    token = box.get('token');
    print("User ID: ${user!.id}");
    print("token: $token");
    context
        .read<CarpoolScreenBloc>()
        .add((FetchUpcomingTrips(userId: user!.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Trips",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MyColors.lightYellow),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: BlocBuilder<CarpoolScreenBloc, CarpoolScreenState>(
            builder: (context, state) {
              if (state is UpcomingTripsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UpcomingTripsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is UpcomingTripsLoaded) {
                // Handle the success state and display the trips
                return ListView.builder(
                  itemCount: state.upcomingTrips.length,
                  itemBuilder: (context, index) => Card(
                    color: MyColors.lightYellow,
                    child: ListTile(
                      leading: const Icon(Icons.directions_car),
                      title: Text(
                          'From: ${state.upcomingTrips[index].startLocationName} to ${state.upcomingTrips[index].endLocationName}'),
                      subtitle: Text("Details about trip ${index + 1}"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to trip detail
                      },
                    ),
                  ),
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
