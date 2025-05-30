import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

class CarpoolCard extends StatelessWidget {
  final String driverName;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime time;
  final int seats;
  final double price;
  final VoidCallback onJoin;
  final VoidCallback onCancel;
  final bool isSelected;

  const CarpoolCard({
    Key? key,
    required this.driverName,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.time,
    required this.seats,
    required this.price,
    required this.onJoin,
    required this.onCancel,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with driver info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Driver avatar
                CircleAvatar(
                  backgroundColor: AppColors.secondaryColor,
                  radius: 24.0,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                
                // Driver info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16.0,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            DateFormat('MMM d, h:mm a').format(time),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '$seats seats',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Divider
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: Colors.grey[200],
          ),
          
          // Route info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route indicators
                Column(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 16.0,
                      color: AppColors.primaryColor,
                    ),
                    Container(
                      width: 2.0,
                      height: 30.0,
                      color: Colors.grey[400],
                    ),
                    Icon(
                      Icons.location_on,
                      size: 16.0,
                      color: AppColors.errorColor,
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                
                // Location text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pickupLocation,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        dropoffLocation,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Row(
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      side: BorderSide(color: AppColors.textColorLight),
                    ),
                    child: Text(
                      'No, Thanks',
                      style: TextStyle(
                        color: AppColors.textColorDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                
                // Join button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onJoin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Join Carpool',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
