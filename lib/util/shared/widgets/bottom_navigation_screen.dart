import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
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
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Cruise',
      style: optionStyle,
    ),
    Text(
      'Rent',
      style: optionStyle,
    ),
    Text(
      'Settings',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.lightGrey,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey[800]!,
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
