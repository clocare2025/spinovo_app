import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spinovo_app/screen/account/account_screen.dart';
import 'package:spinovo_app/screen/booking/booking_screen.dart';
import 'package:spinovo_app/screen/home/home_screen.dart';
import 'package:spinovo_app/utiles/color.dart';

class BottomNavigation extends StatefulWidget {
  final int? indexSet;
  const BottomNavigation({super.key, this.indexSet = 0});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingScreen(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexSet!;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: AppColor.appbarColor,
        unselectedItemColor: const Color(0xFF767B8E),
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}