import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';

class UpcomingTripsWidget extends StatelessWidget {
  const UpcomingTripsWidget({super.key});

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
          child: ListView.builder(
            itemCount: 7, // Replace with your dynamic list
            itemBuilder: (context, index) => Card(
              color: MyColors.lightYellow,
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text("Trip ${index + 1}"),
                subtitle: Text("Details about trip ${index + 1}"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // Navigate to trip detail
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
