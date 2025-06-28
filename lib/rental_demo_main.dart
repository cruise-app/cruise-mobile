import 'package:flutter/material.dart';
import 'package:cruise/features/rental/presentation/views/car_listing_screen.dart';
import 'package:cruise/features/rental/presentation/views/car_booking_screen.dart';
import 'package:cruise/features/rental/presentation/views/car_details_screen.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:cruise/features/rental/data/models/car_model.dart';
import 'package:cruise/features/rental/presentation/views/location_selection_screen.dart';
import 'package:cruise/features/rental/data/models/booking_range.dart';

void main() {
  runApp(const RentalDemoApp());
}

class RentalDemoApp extends StatelessWidget {
  const RentalDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => CarListingScreen(),
        ),
        GoRoute(
          path: '/booking',
          builder: (context, state) => const CarBookingScreen(),
        ),
        GoRoute(
          path: '/details',
          builder: (context, state) {
            CarModel? car;
            int days = 1;
            String? locationStr;
            BookingRange? range;
            if (state.extra is Map) {
              final Map map = state.extra as Map;
              car = map['car'] as CarModel?;
              days = map['days'] as int? ?? 1;
              locationStr = map['location'] as String?;
              if (map.containsKey('range')) {
                final r = map['range'] as Map;
                range = BookingRange(
                  start: DateTime.parse(r['start']),
                  end: DateTime.parse(r['end']),
                );
              }
            } else if (state.extra is CarModel) {
              car = state.extra as CarModel;
            }
            return CarDetailsScreen(
              car: car ?? const CarModel(plateNumber:'',name:'Unknown',category:'',imagePath:'',pricePerDay:0,totalPrice:0,transmission:''),
              bookingDays: days,
              selectedRange: range,
              selectedLocation: locationStr,
            );
          },
        ),
        GoRoute(
          path: '/location',
          builder: (context, state) => const LocationSelectionScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Rental Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: MyColors.black,
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
} 