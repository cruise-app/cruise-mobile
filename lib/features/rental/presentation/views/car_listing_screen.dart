import 'package:cruise/features/rental/presentation/views/widgets/car_card_widget.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/car_model.dart';
import '../../data/models/booking_range.dart';
import '../../data/services/rental_services.dart';
import '../../../../util/shared/app_router.dart';
import 'car_details_screen.dart';

class CarListingScreen extends StatefulWidget {
  CarListingScreen({super.key});

  @override
  State<CarListingScreen> createState() => _CarListingScreenState();
}

class _CarListingScreenState extends State<CarListingScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Electric',
    'Compact',
    'SUV',
    'Sedan',
  ];

  late Future<List<CarModel>> _carsFuture;

  @override
  void initState() {
    super.initState();
    _carsFuture = _loadCars();
  }

  Future<List<CarModel>> _loadCars() async {
    final service = RentalService();
    final either = await service.getAvailableCars({});
    return either.fold((l) {
      // Fallback to local demo data if server fails
      return [
        const CarModel(
            plateNumber: '',
            name: 'Demo Sedan',
            category: 'Sedan',
            imagePath:
                'https://images.unsplash.com/photo-1517142089942-ba376ce32a0e?auto=format&fit=crop&w=800&q=80',
            pricePerDay: 2000,
            totalPrice: 10000,
            transmission: 'Automatic'),
      ];
    }, (r) {
      // If the backend returns an empty list, show demo cars for a richer UI preview.
      if (r.isEmpty) {
        return [
          const CarModel(
              plateNumber: '',
              name: 'Demo Hatchback',
              category: 'Compact',
              imagePath:
                  'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80',
              pricePerDay: 1500,
              totalPrice: 7500,
              transmission: 'Automatic'),
          const CarModel(
              plateNumber: '',
              name: 'Demo EV',
              category: 'Electric',
              imagePath:
                  'https://images.unsplash.com/photo-1593941707874-ef25b8b4a92b?auto=format&fit=crop&w=800&q=80',
              pricePerDay: 1800,
              totalPrice: 9000,
              transmission: 'Automatic'),
        ];
      }
      return r;
    });
  }

  BookingRange? _bookingRange;
  String _location = 'CFC, New Cairo, Egypt';

  List<CarModel> _applyFilter(List<CarModel> all) {
    if (_selectedFilter == 'All') return all;
    return all.where((c) => c.category == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildSearchHeader(context),
              const SizedBox(height: 16),
              _buildFilterRow(),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<CarModel>>(
                  future: _carsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: MyColors.orange));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: \\${snapshot.error}',
                            style: const TextStyle(color: MyColors.lightGrey)),
                      );
                    } else if (snapshot.hasData) {
                      final filtered = _applyFilter(snapshot.data!);
                      return Column(
                        children: [
                          Text(
                            '${filtered.length} cars available in ${_location.split(',').first}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: MyColors.lightYellow,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final int days = _bookingRange == null
                                    ? 1
                                    : (_bookingRange!.end
                                                .difference(_bookingRange!.start)
                                                .inDays)
                                            .clamp(1, 365);
                                return CarCardWidget(
                                  car: filtered[index],
                                  bookingDays: days,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CarDetailsScreen(
                                          car: filtered[index],
                                          bookingDays: days,
                                          selectedLocation: _location,
                                          selectedRange: _bookingRange,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: MyColors.lightYellow),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: MyColors.darkGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await context.push('/location');
                    if (result is String) {
                      setState(() => _location = result);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: MyColors.lightYellow, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        _location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: MyColors.lightYellow,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final result = await context.push('/booking');
                    if (result is BookingRange) {
                      setState(() => _bookingRange = result);
                    }
                  },
                  child: Text(
                    _bookingRange != null
                        ? _formatRange(_bookingRange!)
                        : 'Select dates',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: MyColors.lightGrey,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _filters[index] == _selectedFilter;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = _filters[index];
                });
              },
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? MyColors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? MyColors.orange : MyColors.lightGrey,
                  ),
                ),
                child: Center(
                  child: Text(
                    _filters[index],
                    style: TextStyle(
                      color: isSelected ? MyColors.black : MyColors.lightGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatRange(BookingRange range) {
    final start = range.start;
    final end = range.end;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    String startStr =
        '${start.day} ${months[start.month - 1]}. ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    String endStr =
        '${end.day} ${months[end.month - 1]}. ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$startStr  ->  $endStr';
  }
} 