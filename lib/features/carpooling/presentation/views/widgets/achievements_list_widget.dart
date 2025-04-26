import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';

class AchievementsListWidget extends StatelessWidget {
  const AchievementsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: MyColors.lightYellow,
            child: Text("⭐️ ${index + 1}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )),
          ),
        ),
      ),
    );
  }
}
