import 'package:cruise/features/carpooling/presentation/views/widgets/achievements_list_widget.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/upcoming_trips_widget.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/welcome_message_widget.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/create_trip_screen.dart';

class CarpoolingScreen extends StatefulWidget {
  const CarpoolingScreen({super.key});

  @override
  State<CarpoolingScreen> createState() => _CarpoolingScreenState();
}

class _CarpoolingScreenState extends State<CarpoolingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome Message
            const CarpoolingWelcomeWidget(
                username: "Mohamed", image: Icons.person),
            const SizedBox(height: 16),

            // 2. Achievements List (horizontal)
            const AchievementsListWidget(),
            const SizedBox(height: 20),

            // 3. Search bar + Create button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search trips...',
                      hintStyle: const TextStyle(
                        color: MyColors.lightYellow,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 10, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: MyColors.lightYellow,
                      ),
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
                    backgroundColor: Colors.blue.shade200,
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
    );
  }
}
