import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spinovo_app/utiles/color.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;

  const OtpBox({
    super.key,
    required this.controller,
    this.onChanged,
    required this.focusNode,
    this.nextFocusNode,
    this.previousFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color.fromARGB(215, 160, 160, 160), width: 1),
        color: const Color.fromARGB(213, 255, 255, 255),
      ),
      alignment: Alignment.center,
      child: TextField(
        onTap: () {},
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          hintText: '-',
          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          print('bbbbbbbbbbbbbbbbbbbbb $value');
          if (onChanged != null) {
            onChanged!(value);
          }
          if (value.isNotEmpty && nextFocusNode != null) {
            nextFocusNode!.requestFocus();
          } else if (value.isEmpty && previousFocusNode != null) {
            previousFocusNode!.requestFocus();
          }
        },
      ),
    );
  }
}
