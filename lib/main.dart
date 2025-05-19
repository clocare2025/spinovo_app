import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/otp_model.dart';
import 'package:spinovo_app/screen/address/address_create_screen.dart';
import 'package:spinovo_app/screen/auth/details_screen.dart';
import 'package:spinovo_app/screen/auth/phone_screen.dart';
import 'package:spinovo_app/screen/splash_screen.dart';
import 'package:spinovo_app/services/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    OtpResponse otpResponse = OtpResponse(
      otpCode: '1234',
      mobileNo: '1234567890',
      otpRequest: 'request',
    );
    return 
    // MultiProvider(
      // providers: [
      //   // ChangeNotifierProvider(create: (_) => AuthProvider()),
      //   // ChangeNotifierProvider(create: (_) => NavigationProvider()),
      // ],
      // child: 
      MaterialApp(
        title: 'Spinovo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'SFPro',
        ),
        home: const BottomNavigation(),
        // navigatorKey: NavigationService.navigatorKey,
        // home:  DetailsScreen(otpResponse: otpResponse,),
        // home: const PhoneScreen(),
        // home: const AddressMapScreen(),
      // ),
    );
  }
}
