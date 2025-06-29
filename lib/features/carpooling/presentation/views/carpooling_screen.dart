import 'package:cruise/features/carpooling/presentation/views/widgets/achievements_list_widget.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/upcoming_trips_widget.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/welcome_message_widget.dart';
import 'package:cruise/features/login/data/models/user_model.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:cruise/features/carpooling/presentation/views/carpooling_create_trip_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class CarpoolingScreen extends StatefulWidget {
  const CarpoolingScreen({super.key});

  @override
  State<CarpoolingScreen> createState() => _CarpoolingScreenState();
}

class _CarpoolingScreenState extends State<CarpoolingScreen> {
  late var box;
  UserModel? user;
  String? token;

  void initHive() {
    box = Hive.box('userBox');
    user = box.get('userModel');
    token = box.get('token');
    if (user == null || token == null) {
      // Handle the case where user or token is not found
      print("User or token not found in Hive box.");
    } else {
      print("User: ${user!.userName}, Token: $token");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initHive();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Welcome Message
              CarpoolingWelcomeWidget(
                  username: user!.userName, image: Icons.person),
              const SizedBox(height: 16),

              // 2. Achievements List (horizontal)
              const AchievementsListWidget(),
              const SizedBox(height: 20),

              // 3. Search bar + Create button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.lightYellow,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: MyColors.lightYellow,
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(AppRouter.kCarpoolingSearchScreen,
                                  extra: {
                                    'user': user!,
                                    'token': token!,
                                  });
                            },
                            child: const Text(
                              "Search for trips",
                              style: TextStyle(
                                color: MyColors.lightYellow,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateTripScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: MyColors.black,
                    ),
                    label: const Text(
                      "Create",
                      style: TextStyle(color: MyColors.black, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 4. Upcoming Trips
              const Spacer(),
              const UpcomingTripsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchTripWidget extends StatelessWidget {
  const SearchTripWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search trips...',
        hintStyle: const TextStyle(
          color: MyColors.lightYellow,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 10, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: MyColors.lightYellow,
        ),
      ),
    );
  }
}
