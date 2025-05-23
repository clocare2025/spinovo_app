import 'package:flutter/material.dart';

class AppDesigne {
  static var boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      border: Border.all(
          width: 1.3, color: const Color.fromARGB(152, 217, 222, 216)));

  static var homeScreenBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 192, 192, 192).withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 3,
        offset: const Offset(0, 3),
      ),
    ],
  );
}

BoxDecoration customDateDecoration(selectedDate, date) {
  final bool isSelected = selectedDate == date;

  return BoxDecoration(
    color: isSelected ? const Color(0xFFE9FFEB) : Colors.white,
    border: Border.all(
      color: isSelected ? const Color(0xFF33C362) : Colors.grey[300]!,
    ),
    borderRadius: BorderRadius.circular(8),
  );
}
