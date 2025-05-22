import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/providers/auth_provider.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/router/router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..initAuth()),
        ChangeNotifierProvider(create: (context) => AddressProvider()),
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
      theme: ThemeData(
        fontFamily: 'SFPro',
      ),
      routerConfig: router,
    );
  }
}
