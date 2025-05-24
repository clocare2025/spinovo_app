import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spinovo_app/screen/address/address_screen.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class AppBarCheckout extends StatelessWidget {
  const AppBarCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColor.textColor),
        onPressed: () => context.pop(),
      ),
      title: CustomText(
        text: "Home | i-hub Gujrat",
        size: 15,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddressScreen()),
            );
          },
          child: CustomText(
            text: "Change",
            size: 15,
            color: AppColor.appbarColor,
          ),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
