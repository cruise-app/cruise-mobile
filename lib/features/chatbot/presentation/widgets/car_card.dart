import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/car.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final bool isSelected;
  final VoidCallback onTap;

  const CarCard({
    Key? key,
    required this.car,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColorLight : AppColors.cardColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Car image
            Container(
              width: 80.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(car.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16.0),

            // Car details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.model,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    car.plateNumber,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    _getCarTypeText(car.type),
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),

            // Price and time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${car.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '${car.estimatedTimeMin} min',
                    style: TextStyle(
                      color: AppColors.successColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCarTypeText(CarType type) {
    switch (type) {
      case CarType.standard:
        return 'Standard';
      case CarType.comfort:
        return 'Comfort';
      case CarType.luxury:
        return 'Luxury';
      case CarType.suv:
        return 'SUV';
      default:
        return 'Standard';
    }
  }
}
