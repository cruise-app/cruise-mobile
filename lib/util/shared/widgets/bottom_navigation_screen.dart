import 'package:cruise/features/carpooling/presentation/manager/carpool_screen_manager/carpool_screen_bloc.dart';
import 'package:cruise/features/carpooling/presentation/views/carpooling_screen.dart';
import 'package:cruise/features/carpooling/presentation/views/carpooling_create_trip_screen.dart';
import 'package:cruise/features/settings/settings_screen.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    const Text(
      'Home',
      style: optionStyle,
    ),
    BlocProvider(
        create: (context) => CarpoolScreenBloc(),
        child: const CarpoolingScreen()),
    const Text(
      'Rent',
      style: optionStyle,
    ),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.black,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          color: MyColors.lightYellow,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
                backgroundColor: MyColors.lightYellow,
                color: Colors.black,
                activeColor: Colors.black,
                tabBackgroundColor: Colors.grey[400]!,
                padding: const EdgeInsets.all(16),
                gap: 5,
                onTabChange: (value) => setState(() {
                      _selectedIndex = value;
                    }),
                iconSize: 20,
                tabs: const [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: LineIcons.carSide, text: 'Cruise'),
                  GButton(icon: Icons.handshake, text: 'Rent'),
                  GButton(icon: Icons.settings, text: 'settings'),
                ]),
          ),
        ));
  }
}
