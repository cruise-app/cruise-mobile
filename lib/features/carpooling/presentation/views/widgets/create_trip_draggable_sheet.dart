import 'package:cruise/features/carpooling/presentation/manager/create_trip_bloc.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

// ignore: must_be_immutable
class CreateTripDraggableSheet extends StatefulWidget {
  const CreateTripDraggableSheet({super.key});

  @override
  _CreateTripDraggableSheetState createState() =>
      _CreateTripDraggableSheetState();
}

class _CreateTripDraggableSheetState extends State<CreateTripDraggableSheet> {
  TextEditingController startLocationController = TextEditingController();
  TextEditingController endLocationController = TextEditingController();
  List<String> suggestions = [];
  FocusNode startLocationFocusNode = FocusNode();
  FocusNode endLocationFocusNode = FocusNode();
  String? activeField; // Track which field is active
  Timer? _debounce; // Timer for debouncing

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
        context.read<CreateTripBloc>().add(
              SearchingLocation(location: value),
            );
      },
    );
  }

  void dispose() {
    startLocationController.dispose();
    endLocationController.dispose();
    startLocationFocusNode.dispose();
    endLocationFocusNode.dispose();
    _debounce?.cancel(); // Cancel the timer if it exists
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8, // 20% of screen height initially
      minChildSize: 0.05, // minimum when collapsed
      maxChildSize: 0.8, // maximum when expanded
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {
            // Unfocus when tapping anywhere outside the TextField
            startLocationFocusNode.unfocus();
            endLocationFocusNode.unfocus();
          },
          child: Container(
            decoration: const BoxDecoration(
              color: MyColors.lightYellow,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Column(
                  children: [
                    const SizedBox(height: 5),
                    const Center(
                      child: Icon(
                        Icons.drag_handle_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    const Text(
                      'Create your Trip',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: MyColors.black, width: 3),
                      ),
                      child: Column(
                        children: [
                          // Start Location field
                          TextFormField(
                            controller: startLocationController,
                            focusNode: startLocationFocusNode,
                            cursorColor: MyColors.black,
                            onChanged: (value) {
                              // Directly dispatch the event without BlocBuilder
                              //print("Searching for: $value");
                              textFieldLogic(value, 'startLocation');
                              activeField = 'startLocation';
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.trip_origin),
                              border: InputBorder.none,
                              labelText: 'Start Location',
                            ),
                          ),
                          const Divider(
                            color: MyColors.lightGrey,
                            thickness: 0.5,
                            height: 8,
                          ),
                          // End Location field
                          TextFormField(
                            onChanged: (value) {
                              // Directly dispatch the event without BlocBuilder
                              textFieldLogic(value, 'endLocation');
                              activeField = 'endLocation';
                            },
                            controller: endLocationController,
                            focusNode: endLocationFocusNode,
                            cursorColor: MyColors.black,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_pin),
                              border: InputBorder.none,
                              labelText: 'End Location',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Handle event without BlocBuilder
                    BlocListener<CreateTripBloc, CreateTripState>(
                      listener: (context, state) {
                        // You can handle state changes here if needed
                        if (state is LocationSearchingState &&
                            state.suggestions.isNotEmpty) {
                          setState(() {
                            suggestions = state.suggestions;
                          });
                        }
                      },
                      child: Column(
                        children: [
                          // Only show the list if there are suggestions
                          if (suggestions.isNotEmpty)
                            SizedBox(
                              height:
                                  150, // Set a height to make the list scrollable
                              child: ListView.builder(
                                itemCount: suggestions.length,
                                itemBuilder: (_, index) {
                                  return ListTile(
                                    title: Text(suggestions[index]),
                                    onTap: () {
                                      // Handle location selection
                                      if (activeField == 'startLocation') {
                                        startLocationController.text =
                                            suggestions[index];
                                      } else if (activeField == 'endLocation') {
                                        endLocationController.text =
                                            suggestions[index];
                                      }
                                      setState(() {
                                        suggestions
                                            .clear(); // Clear suggestions after selection
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
