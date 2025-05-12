import 'package:flutter/material.dart';
import 'package:spinovo_app/utiles/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorCont.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(child: Image.asset("asset/images/logo.png")),
      ),
    );
  }
}
