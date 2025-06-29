import 'package:flutter/material.dart';
import 'package:cruise/util/shared/colors.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final _controller = TextEditingController();
  final List<String> _allLocations = const [
    'CFC, New Cairo, Egypt',
    'Nasr City, Cairo, Egypt',
    '6th October, Giza, Egypt',
    'Alexandria, Egypt',
    'Sharm El Sheikh, Egypt',
  ];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _allLocations
        .where((loc) => loc.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: MyColors.black,
      appBar: AppBar(
        backgroundColor: MyColors.black,
        title: const Text('Select Location', style: TextStyle(color: MyColors.lightYellow)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: MyColors.lightYellow),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: MyColors.lightGrey),
                prefixIcon: const Icon(Icons.search, color: MyColors.lightGrey),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: MyColors.darkGrey)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: MyColors.orange)),
              ),
              onChanged: (val) => setState(() => _query = val),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(color: MyColors.darkGrey),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filtered[index], style: const TextStyle(color: MyColors.lightYellow)),
                  onTap: () => Navigator.pop(context, filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 