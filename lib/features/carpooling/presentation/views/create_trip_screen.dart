import 'package:cruise/features/carpooling/presentation/manager/create_trip_bloc.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/create_trip_app_bar.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/create_trip_draggable_sheet.dart';
import 'package:cruise/features/carpooling/presentation/views/widgets/google_maps_widget.dart';
import 'package:cruise/features/login/data/models/user_model.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  LatLng? myCurrentLocation;
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  late var box;
  UserModel? user;
  String? token;

  // FocusNode for controlling the focus of the TextField
  FocusNode startLocationFocusNode = FocusNode();
  FocusNode endLocationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    box = Hive.box('userBox');
    user = box.get('userModel');
    token = box.get('token');
    _initLocation();
  }

  Future<void> _initLocation() async {
    Position position = await _getCurrentPosition();
    LatLng initialLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      myCurrentLocation = initialLocation;
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: initialLocation,
          infoWindow: const InfoWindow(
            title: 'My Location',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.lightYellow,
      body: GestureDetector(
        onTap: () {
          // Unfocus when tapping anywhere outside the TextField
          startLocationFocusNode.unfocus();
          endLocationFocusNode.unfocus();
        },
        child: myCurrentLocation == null
            ? const Center(
                child: CircularProgressIndicator(
                color: MyColors.black,
              ))
            : Stack(
                children: [
                  // Top Black AppBar

                  GoogleMapsWidget(
                    myCurrentLocation: myCurrentLocation!,
                    markers: markers,
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                  CreateTripAppBar(username: user!.userName, rating: "4.5"),
                  // Bottom Draggable Sheet
                  BlocProvider(
                    create: (context) => CreateTripBloc(),
                    child: CreateTripDraggableSheet(
                      user: user,
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.black,
        onPressed: () async {
          Position position = await _getCurrentPosition();
          LatLng newLocation = LatLng(position.latitude, position.longitude);

          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: newLocation, zoom: 14),
            ),
          );

          setState(() {
            myCurrentLocation = newLocation;
            markers.clear();
            markers.add(
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: newLocation,
                infoWindow: const InfoWindow(title: 'My Location'),
              ),
            );
          });
        },
        child: const Icon(
          Icons.my_location,
          color: MyColors.lightYellow,
        ),
      ),
    );
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
