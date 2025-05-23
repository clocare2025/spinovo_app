import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/utiles/constants.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), _checkLoggedIn);
  }

  Future<void> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    print("authProvider.token ${token}");
    if (token != null && token.isNotEmpty) {
      // ignore: use_build_context_synchronously
      context.go('/home');
    } else {
      // ignore: use_build_context_synchronously
      context.go('/phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF33C162),
              Color(0xFF20783E),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Spinovo',
                  color: Colors.white,
                  size: 55,
                  fontweights: FontWeight.bold,
                ),
                const Divider(
                  thickness: 0.8,
                  color: Color.fromARGB(119, 218, 218, 218),
                ),
                CustomText(
                  text: 'India\'s First Quick Laundry Service App',
                  color: Colors.white,
                  fontweights: FontWeight.w400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
