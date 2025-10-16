import 'package:spinovo_app/providers/order_place_provider.dart';
import 'package:spinovo_app/providers/paymentMode_provider.dart';
import 'package:spinovo_app/providers/location_provider.dart';
import 'package:spinovo_app/providers/timeslot_provider.dart';
import 'package:spinovo_app/providers/services_provider.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/providers/package_provider.dart';
import 'package:spinovo_app/providers/profile_provider.dart';
import 'package:spinovo_app/providers/wallet_provider.dart';
import 'package:spinovo_app/providers/order_provider.dart';
import 'package:spinovo_app/providers/auth_provider.dart';
import 'package:spinovo_app/router/router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..initAuth()),
        ChangeNotifierProvider(create: (context) => AddressProvider()),
        ChangeNotifierProvider(create: (context) => TimeslotProvider()),
        ChangeNotifierProvider(create: (context) => ServicesProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
        ChangeNotifierProvider(create: (context) => PackageProvider()),
        ChangeNotifierProvider( create: (context) => ProfileProvider(),
        ), // Add this provider
        ChangeNotifierProvider(create: (context) => PaymentModeProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(
          create: (context) => OrderPlaceDetailsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Spinovo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'SFPro', useMaterial3: true),
      routerConfig: router,
    );
  }
}
