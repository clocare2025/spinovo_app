import 'package:flutter/material.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool? isBack;
  const CustomAppBar({
    super.key,
    required this.title,
    this.isBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: isBack == true
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      title: CustomText(
        text: title,
        size: 20,
        fontweights: FontWeight.w500,
      ),
      backgroundColor: Colors.white,
      elevation: 0.3,
      shadowColor: const Color.fromARGB(255, 210, 210, 210),
    );
  }
}
