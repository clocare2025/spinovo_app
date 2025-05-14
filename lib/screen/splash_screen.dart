import 'package:flutter/material.dart';
import 'package:spinovo_app/utiles/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.topCenter,
          colors: [
            Color(0xFF33C162),
            Color(0xFF20783E),
          ],
        )),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(child: Image.asset("asset/images/logo.png")),
        ),
      ),
    );
  }
}
