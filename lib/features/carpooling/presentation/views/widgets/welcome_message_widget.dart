import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';

class CarpoolingWelcomeWidget extends StatelessWidget {
  const CarpoolingWelcomeWidget(
      {super.key, required this.username, required this.image});
  final String username;
  final IconData image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "Welcome,\n$username!",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontWeight: FontWeight.bold,
                  color: MyColors.lightYellow),
              overflow: TextOverflow
                  .ellipsis, // optional: adds "..." if text is too long
            ),
          ),
          const SizedBox(width: 35), // spacing between text and icon
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.lightYellow.withOpacity(0.2),
            ),
            padding: const EdgeInsets.all(3),
            child: Icon(
              image,
              size: MediaQuery.of(context).size.width * 0.25,
              color: MyColors.lightYellow,
            ),
          ),
        ],
      ),
    );
  }
}
