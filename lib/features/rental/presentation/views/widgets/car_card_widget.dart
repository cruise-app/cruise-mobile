import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/car_model.dart';

class CarCardWidget extends StatelessWidget {
  final CarModel car;
  final int bookingDays;
  final VoidCallback? onTap;

  const CarCardWidget({super.key, required this.car, this.onTap, this.bookingDays = 1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MyColors.darkGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Category Badge
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  car.category,
                  style: const TextStyle(
                    color: MyColors.lightGrey,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Hero(
                    tag: 'car_${car.name}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: car.imagePath,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: MyColors.darkGrey,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: MyColors.orange,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.broken_image,
                          color: MyColors.lightGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Car name
                Text(
                  car.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: MyColors.lightYellow,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                // Transmission and similar label
                Row(
                  children: [
                    const Icon(Icons.settings, color: MyColors.lightGrey, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      car.transmission,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: MyColors.lightGrey,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'or similar',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: MyColors.lightGrey,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Rating Row
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      car.rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: MyColors.lightYellow,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Price Row
                Row(
                  children: [
                    Text(
                      'LE ${car.pricePerDay} per day',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: MyColors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${car.pricePerDay * bookingDays}) total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: MyColors.lightGrey,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 