import 'package:flutter/material.dart';
import 'package:spinovo_app/screen/home_screen.dart';
import 'package:spinovo_app/screen/splash_screen.dart';
import 'package:spinovo_app/services/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spinovo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home:  BottomNavigation(),
    );
  }
}
