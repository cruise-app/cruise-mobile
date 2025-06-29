import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/models/booking_range.dart';

class CarBookingScreen extends StatefulWidget {
  const CarBookingScreen({super.key});

  @override
  State<CarBookingScreen> createState() => _CarBookingScreenState();
}

class _CarBookingScreenState extends State<CarBookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _startDay;
  DateTime? _endDay;
  TimeOfDay _startTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 19, minute: 0);
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.black,
      appBar: AppBar(
        backgroundColor: MyColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyColors.lightYellow),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Cairo, Egypt',
          style: TextStyle(color: MyColors.lightYellow),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: MyColors.lightYellow),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              rangeStartDay: _startDay,
              rangeEndDay: _endDay,
              rangeSelectionMode: _rangeSelectionMode,
              enabledDayPredicate: (day) {
                // Disable past dates
                return !day.isBefore(DateTime.now().subtract(const Duration(days: 1)));
              },
              onPageChanged: (focusedDay) => setState(() => _focusedDay = focusedDay),
              onDaySelected: (selectedDay, focusedDay) {
                // Prevent selecting past dates
                if (selectedDay.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                  return;
                }
                // Start a new range on first tap
                setState(() {
                  _startDay = selectedDay;
                  _endDay = null;
                  _focusedDay = focusedDay;
                  _rangeSelectionMode = RangeSelectionMode.toggledOn;
                });
              },
              onRangeSelected: (start, end, focusedDay) {
                // Prevent selecting past dates
                if (start != null && start.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                  return;
                }
                if (end != null && end.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                  return;
                }
                setState(() {
                  _startDay = start;
                  _endDay = end;
                  _focusedDay = focusedDay;
                  _rangeSelectionMode = RangeSelectionMode.toggledOn;
                });
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(color: MyColors.orange, shape: BoxShape.circle),
                rangeHighlightColor: Color(0xFF3A3215),
                rangeStartDecoration: BoxDecoration(color: MyColors.orange, shape: BoxShape.circle),
                rangeEndDecoration: BoxDecoration(color: MyColors.orange, shape: BoxShape.circle),
                defaultTextStyle: TextStyle(color: MyColors.lightGrey),
                weekendTextStyle: TextStyle(color: MyColors.lightGrey),
                outsideTextStyle: TextStyle(color: MyColors.lightGrey),
                disabledTextStyle: TextStyle(color: Color(0xFF444444)),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: MyColors.lightGrey),
                weekendStyle: TextStyle(color: MyColors.lightGrey),
              ),
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(color: MyColors.lightYellow),
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: MyColors.lightYellow),
                rightChevronIcon: Icon(Icons.chevron_right, color: MyColors.lightYellow),
              ),
            ),
            const SizedBox(height: 24),
            _buildTimeSelector('Start', _startTime, (value) => setState(() => _startTime = value)),
            const SizedBox(height: 12),
            _buildTimeSelector('End', _endTime, (value) => setState(() => _endTime = value)),
            const SizedBox(height: 24),
            _buildSummarySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(String label, TimeOfDay time, ValueChanged<TimeOfDay> onChanged) {
    return Row(
      children: [
        const Icon(Icons.circle, color: MyColors.orange, size: 8),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: MyColors.lightGrey)),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: MyColors.orange,
                        onSurface: MyColors.lightYellow,
                      ),
                      timePickerTheme: const TimePickerThemeData(
                        backgroundColor: MyColors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) onChanged(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.darkGrey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                time.format(context),
                style: const TextStyle(color: MyColors.lightYellow),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    final durationInDays = _startDay != null && _endDay != null
        ? _endDay!.difference(_startDay!).inHours / 24.0
        : 0;
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              durationInDays > 0
                  ? '${durationInDays.toStringAsFixed(1)} day'
                  : 'Select range',
              style: const TextStyle(color: MyColors.lightYellow),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              backgroundColor: MyColors.orange,
              onPressed: () {
                if (_startDay != null && _endDay != null) {
                  final startDateTime = DateTime(
                      _startDay!.year,
                      _startDay!.month,
                      _startDay!.day,
                      _startTime.hour,
                      _startTime.minute);
                  final endDateTime = DateTime(
                      _endDay!.year,
                      _endDay!.month,
                      _endDay!.day,
                      _endTime.hour,
                      _endTime.minute);
                  Navigator.pop(context,
                      BookingRange(start: startDateTime, end: endDateTime));
                }
              },
              child: const Icon(Icons.check, color: MyColors.black),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
} 