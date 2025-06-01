import 'package:cruise/features/carpooling/presentation/views/widgets/date_time_widget.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';

class SearchLocationBox extends StatefulWidget {
  const SearchLocationBox(
      {super.key,
      required this.startLocationController,
      required this.endLocationController,
      required this.startLocationFocusNode,
      required this.endLocationFocusNode,
      required this.onStartLocationChanged,
      required this.onEndLocationChanged,
      required this.activeField,
      required this.selectedDateTimeFromChild});

  // Change these to actual TextEditingController instead of Function
  final TextEditingController startLocationController;
  final TextEditingController endLocationController;
  final FocusNode startLocationFocusNode;
  final FocusNode endLocationFocusNode;
  final ValueChanged<String> onStartLocationChanged;
  final ValueChanged<String> onEndLocationChanged;
  final String? activeField;
  final Function(DateTime?) selectedDateTimeFromChild;

  @override
  State<SearchLocationBox> createState() => _SearchLocationBoxState();
}

class _SearchLocationBoxState extends State<SearchLocationBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search for Carpooling Rides',
            style: TextStyle(
              color: MyColors.lightYellow,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16), // Space between title and fields
          Container(
            decoration: BoxDecoration(
              color: MyColors.lightYellow,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextFormField(
              onEditingComplete: () {
                print('Editing complete for start location');
                widget.startLocationFocusNode.unfocus();
              },
              onChanged: widget.onStartLocationChanged,
              controller: widget.startLocationController,
              focusNode: widget.startLocationFocusNode,
              cursorColor: MyColors.black,
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(
                  Icons.trip_origin,
                  size: 24,
                ),
                border: InputBorder.none,
                labelText: 'Start Location',
              ),
            ),
          ),
          const SizedBox(height: 16), // Space between fields
          // Add the end location field too
          Container(
            decoration: BoxDecoration(
              color: MyColors.lightYellow,
              borderRadius: BorderRadius.circular(5),
              // Space between fields
            ),
            child: TextFormField(
              onEditingComplete: () {
                print('Editing complete for end location');
                widget.endLocationFocusNode.unfocus();
              },
              onChanged: widget.onEndLocationChanged,
              controller: widget.endLocationController,
              focusNode: widget.endLocationFocusNode,
              cursorColor: MyColors.black,
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(
                  Icons.location_on,
                  size: 24,
                ),
                border: InputBorder.none,
                labelText: 'End Location',
              ),
            ),
          ),
          const SizedBox(height: 16), // Space between fields
          DateTimeWidget(
            backgroundColor: MyColors.lightYellow,
            onDateTimeSelected: widget.selectedDateTimeFromChild,
          ),
        ],
      ),
    );
  }
}
