import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

// ignore: must_be_immutable
class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({
    super.key,
    required this.onDateTimeSelected,
    this.backgroundColor,
  });

  final ValueChanged<DateTime?> onDateTimeSelected;
  final Color? backgroundColor;

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickedDateTime = await showOmniDateTimePicker(
          type: OmniDateTimePickerType.dateAndTime,
          context: context,
          is24HourMode: false,
          initialDate: DateTime.now(),
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: MyColors.black,
            ),
          ),
        );
        if (pickedDateTime != null) {
          setState(() {
            _selectedDateTime = pickedDateTime;
          });
          widget.onDateTimeSelected(pickedDateTime);
        }
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(6),
          // border: Border.all(color: MyColors.black, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.calendar_today, color: Colors.black),
              Text(
                _selectedDateTime != null
                    ? '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} '
                        '${_formatTime(_selectedDateTime!)}'
                    : 'Select Date and Time',
                style: const TextStyle(color: Colors.black),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
