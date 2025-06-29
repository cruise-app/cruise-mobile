import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/car_model.dart';
import '../../data/models/booking_range.dart';
import '../../data/services/rental_services.dart';
import 'package:dartz/dartz.dart';
import 'package:cruise/util/shared/failure_model.dart';

class CarDetailsScreen extends StatelessWidget {
  final CarModel car;
  final int bookingDays;
  final String? selectedLocation;
  final BookingRange? selectedRange;
  const CarDetailsScreen({super.key, required this.car, this.bookingDays = 1, this.selectedLocation, this.selectedRange});

  bool _isDateOverlapping(DateTime start, DateTime end, List<Map<String, dynamic>> reservations) {
    for (var reservation in reservations) {
      final resStart = DateTime.parse(reservation['startDate']);
      final resEnd = DateTime.parse(reservation['endDate']);
      
      // Check if the new booking overlaps with existing reservation
      if ((start.isBefore(resEnd) && end.isAfter(resStart)) ||
          (start.millisecondsSinceEpoch == resStart.millisecondsSinceEpoch || 
           end.millisecondsSinceEpoch == resEnd.millisecondsSinceEpoch)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: MyColors.black,
        appBar: AppBar(
          backgroundColor: MyColors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: MyColors.lightYellow),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            car.name,
            style: const TextStyle(color: MyColors.lightYellow),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: MyColors.lightYellow),
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            )
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: MyColors.lightYellow,
            unselectedLabelColor: MyColors.lightGrey,
            indicatorColor: MyColors.orange,
            tabs: [
              Tab(text: 'Gallery'),
              Tab(text: 'Price'),
              Tab(text: 'Highlights'),
              Tab(text: 'Report'),
            ],
          ),
        ),
        floatingActionButton: FutureBuilder<Either<Failure, List<Map<String, dynamic>>>>(
          future: RentalService().getReservations(car.plateNumber),
          builder: (context, snapshot) {
            final reservations = snapshot.data?.fold((l) => <Map<String, dynamic>>[], (r) => r) ?? [];
            final isOverlapping = selectedRange != null && 
                _isDateOverlapping(selectedRange!.start, selectedRange!.end, reservations);
            
            return FloatingActionButton.extended(
              onPressed: selectedRange == null || isOverlapping ? null : () async {
                final service = RentalService();
                final either = await service.reserveCar(
                  carId: car.plateNumber,
                  renterId: 'demo-user', // TODO replace with auth user id
                  startDate: selectedRange!.start,
                  endDate: selectedRange!.end,
                  pickupLocation: {'lat': 0, 'lng': 0},
                );
                either.fold(
                  (l) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reservation failed: ${l.message}')),
                  ),
                  (r) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Car reserved successfully!')),
                    );
                    // Navigate back to refresh the list
                    Navigator.of(context).pop();
                  },
                );
              },
              label: Text(isOverlapping ? 'Period Unavailable' : 'Reserve'),
              icon: Icon(isOverlapping ? Icons.block : Icons.car_rental),
              backgroundColor: isOverlapping ? MyColors.darkGrey : MyColors.orange,
            );
          },
        ),
        body: TabBarView(
          children: [
            _buildGalleryTab(car),
            _buildPriceTab(car),
            _buildHighlightsTab(car),
            _buildReportTab(car),
          ],
        ),
        bottomNavigationBar: FutureBuilder<Either<Failure, List<Map<String, dynamic>>>>(
          future: RentalService().getReservations(car.plateNumber),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return snapshot.data!.fold(
              (_) => const SizedBox.shrink(),
              (list) => list.isEmpty
                  ? const SizedBox.shrink()
                  : Container(
                      color: MyColors.darkGrey,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, color: MyColors.lightYellow, size: 16),
                              const SizedBox(width: 8),
                              const Text('Reserved periods:', 
                                style: TextStyle(color: MyColors.lightYellow, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final res = list[index];
                                final s = DateTime.parse(res['startDate']);
                                final en = DateTime.parse(res['endDate']);
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: MyColors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: MyColors.orange),
                                  ),
                                  child: Text(
                                    '${s.day}/${s.month} - ${en.day}/${en.month}',
                                    style: const TextStyle(color: MyColors.orange, fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGalleryTab(CarModel car) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Hero(
              tag: 'car_${car.name}',
              child: CachedNetworkImage(
                imageUrl: car.imagePath,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: MyColors.darkGrey,
                  child: const Center(
                    child: CircularProgressIndicator(color: MyColors.orange),
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image, color: MyColors.lightGrey),
                ),
              ),
            ),
          ),
          Container(
            color: MyColors.darkGrey,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(car.name,
                          style: const TextStyle(
                              color: MyColors.lightYellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 2),
                    Text(car.rating.toStringAsFixed(1),
                        style: const TextStyle(color: MyColors.lightYellow)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(car.description,
                    style:
                        const TextStyle(color: MyColors.lightGrey, fontSize: 12)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('EGP ${car.pricePerDay} Per Day',
                        style: const TextStyle(
                            color: MyColors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Spacer(),
                    Text('${car.pricePerDay * bookingDays} Total',
                        style: const TextStyle(
                          color: MyColors.lightGrey,
                          decoration: TextDecoration.underline,
                        )),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(Icons.local_offer_outlined,
                        color: MyColors.lightGrey, size: 16),
                    SizedBox(width: 6),
                    Text('View all Price benefits',
                        style: TextStyle(color: MyColors.lightGrey, fontSize: 12)),
                    Spacer(),
                    Icon(Icons.chevron_right, color: MyColors.lightGrey, size: 16),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            tileColor: MyColors.black,
            leading: const Icon(Icons.location_on, color: MyColors.lightYellow),
            title: Text(selectedLocation ?? car.location,
                style:
                    const TextStyle(color: MyColors.lightYellow, fontSize: 14)),
            trailing: const Icon(Icons.chevron_right, color: MyColors.lightGrey),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Car Summary',
                style: const TextStyle(
                    color: MyColors.lightYellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: MyColors.darkGrey, width: 1)),
              child: Column(
                children: const [
                  _BulletItem(text: 'No repainted parts'),
                  _BulletItem(text: 'No mechanical problems'),
                  _BulletItem(
                      text:
                          'New maintenance in the authorized service center'),
                  _BulletItem(text: 'Car in warranty'),
                  _BulletItem(text: 'New front and back tires'),
                  _BulletItem(text: 'New front and rear brake pads'),
                  _BulletItem(text: 'New front brake discs'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPriceTab(CarModel car) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EGP ${car.pricePerDay} Per Day',
            style: const TextStyle(
                color: MyColors.orange, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('${car.pricePerDay * bookingDays} Total',
              style: const TextStyle(color: MyColors.lightYellow)),
          const SizedBox(height: 16),
          const Divider(color: MyColors.darkGrey),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.check, color: MyColors.orange),
            title: const Text('No mechanical problems',
                style: TextStyle(color: MyColors.lightYellow)),
          ),
          ListTile(
            leading: const Icon(Icons.check, color: MyColors.orange),
            title: const Text('New maintenance in authorized service center',
                style: TextStyle(color: MyColors.lightYellow)),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsTab(CarModel car) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Car Summary',
              style: TextStyle(
                  color: MyColors.lightYellow, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          _BulletItem(text: 'No repainted parts'),
          _BulletItem(text: 'Car in warranty'),
          _BulletItem(text: 'New front brake pads'),
        ],
      ),
    );
  }

  Widget _buildReportTab(CarModel car) {
    return ListView(
      children: const [
        ListTile(
          title: Text('Exteriors & Repainted Parts',
              style: TextStyle(color: MyColors.lightYellow)),
          trailing: Icon(Icons.chevron_right, color: MyColors.lightGrey),
        ),
        Divider(color: MyColors.darkGrey, height: 1),
        ListTile(
          title: Text('Interiors & AC',
              style: TextStyle(color: MyColors.lightYellow)),
          trailing: Icon(Icons.chevron_right, color: MyColors.lightGrey),
        ),
        Divider(color: MyColors.darkGrey, height: 1),
        ListTile(
          title:
              Text('Consumables', style: TextStyle(color: MyColors.lightYellow)),
          trailing: Icon(Icons.chevron_right, color: MyColors.lightGrey),
        ),
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check, color: MyColors.orange, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: MyColors.lightGrey)),
          ),
        ],
      ),
    );
  }
} 