import 'package:flutter/material.dart';
import 'package:spinovo_app/screen/account/account_screen.dart';
import 'package:spinovo_app/screen/booking/booking_screen.dart';
import 'package:spinovo_app/screen/home/home_screen.dart';
import 'package:spinovo_app/utiles/color.dart';


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

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingScreen(),
    const AccountScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentIndex = widget.indexset!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Show selected screen
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
            icon:  Icon(Icons.list_alt_rounded),
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
