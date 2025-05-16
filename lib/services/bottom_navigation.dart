import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:spinovo_app/screen/account_screen.dart';
import 'package:spinovo_app/screen/booking_screen.dart';
import 'package:spinovo_app/screen/home_screen.dart';

class BottomNavigation extends StatefulWidget {
  final int? indexset;
  const BottomNavigation({
    super.key,
    this.indexset = 0,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingScreen(),
    const AccountScreen(),
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _onItemTapped(widget.indexset!);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_filled),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.list_alt_rounded),
            label: 'Booking',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
        onTap: (index) {
          // Handle button tap
        },
      ),
      body: _screens[_selectedIndex],
    );
  }
}
