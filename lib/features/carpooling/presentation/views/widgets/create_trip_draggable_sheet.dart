import 'package:cruise/features/carpooling/presentation/manager/create_trip_bloc.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/date_time_widget.dart';
import 'package:cruise/features/login/data/models/user_model.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

// ignore: must_be_immutable
class CreateTripDraggableSheet extends StatefulWidget {
  const CreateTripDraggableSheet(
      {super.key, required this.user, required this.onPolylineReady});
  final UserModel? user;
  final Function(List<LatLng> polyline, LatLng start, LatLng end)
      onPolylineReady;
  // Callback for polyline update
  @override
  // ignore: library_private_types_in_public_api
  _CreateTripDraggableSheetState createState() =>
      _CreateTripDraggableSheetState();
}

class _CreateTripDraggableSheetState extends State<CreateTripDraggableSheet> {
  TextEditingController startLocationController = TextEditingController();
  TextEditingController endLocationController = TextEditingController();
  DateTime? selectedDateTimeFromChild;
  List<String> suggestions = [];
  FocusNode startLocationFocusNode = FocusNode();
  FocusNode endLocationFocusNode = FocusNode();
  String? activeField; // Track which field is active
  Timer? _debounce; // Timer for debouncing
  List<String> vehicleTypes = [
    'Sedan',
    'SUV',
    'Minibus',
    "Motorcycle",
  ];
  String? selectedVehicleType; // Track selected vehicle type

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

  void getPolyLine() {
    print("Fetching polyline for review");
    context.read<CreateTripBloc>().add(
          FetchPolylineForReview(
            startLocationName: startLocationController.text,
            endLocationName: endLocationController.text,
          ),
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

                    // Date and Time field
                    DateTimeWidget(
                      onDateTimeSelected: (dateTime) {
                        setState(() {
                          selectedDateTimeFromChild = dateTime;
                        });
                        print('Selected DateTime: $dateTime');
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: MyColors.black, width: 3),
                        color: MyColors.lightYellow,
                      ),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: const Text("Select Vehicle Type"),
                          value: selectedVehicleType,
                          onChanged: (value) {
                            setState(() {
                              selectedVehicleType = value;
                            });
                          },
                          items: vehicleTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: MyColors.black, width: 3),
                      ),
                      child: Column(
                        children: [
                          // Start Location field
                          TextFormField(
                            onEditingComplete: () {
                              print('Editing complete for start location');
                              startLocationFocusNode.unfocus();
                            },
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
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: MyColors.black, width: 3),
                      ),
                      child: ActionButton(
                        message: 'Show Route',
                        action: () {
                          context.read<CreateTripBloc>().add(
                                FetchPolylineForReview(
                                  startLocationName:
                                      startLocationController.text,
                                  endLocationName: endLocationController.text,
                                ),
                              );
                        },
                        textStyle: const TextStyle(
                          color: MyColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        height: 35,
                        color: MyColors.lightYellow,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: MyColors.black, width: 3),
                      ),
                      child: ActionButton(
                        message: 'Create',
                        action: () {
                          print(
                              "Start Location: ${startLocationController.text}");
                          print("End Location: ${endLocationController.text}");
                          print("Selected Vehicle Type: $selectedVehicleType");
                          print(
                              "Date and Time: ${selectedDateTimeFromChild?.toUtc().toString()}");
                          if (selectedDateTimeFromChild != null &&
                              startLocationController.text.isNotEmpty &&
                              endLocationController.text.isNotEmpty &&
                              selectedVehicleType != null) {
                            context.read<CreateTripBloc>().add(
                                  CreateTripSubmitted(
                                    driverID: widget.user!.id,
                                    departureTime: selectedDateTimeFromChild!
                                        .toUtc()
                                        .toString(),
                                    startLocationName:
                                        startLocationController.text,
                                    endLocationName: endLocationController.text,
                                    vehicleType: selectedVehicleType!,
                                  ),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        textStyle: const TextStyle(
                          color: MyColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        height: 35,
                        color: MyColors.lightYellow,
                      ),
                    ),

                    BlocListener<CreateTripBloc, CreateTripState>(
                      listener: (context, state) {
                        if (state is CreateTripSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else if (state is CreateTripErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (state is PolylineForReviewState) {
                          print("Polyline for review here : ${state.polyline}");
                          print(
                              "Start Location for review here : ${state.startLocation}");
                          print(
                              "End Location for review here : ${state.endLocation}");
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            widget.onPolylineReady(state.polyline,
                                state.startLocation, state.endLocation);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Polyline ready for review'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        } else if (state is PolylineErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(), // Empty container to use BlocListener
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
