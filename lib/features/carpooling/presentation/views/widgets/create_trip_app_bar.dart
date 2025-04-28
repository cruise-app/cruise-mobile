import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';

class CreateTripAppBar extends StatelessWidget {
  const CreateTripAppBar(
      {super.key, required this.username, required this.rating});
  final String username;
  final String rating;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: const BoxDecoration(
        color: MyColors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: MyColors.lightYellow,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Text(
                      '4.5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                //Rating Widget
              ],
            )
          ],
        ),
      ),
    );
  }
}
