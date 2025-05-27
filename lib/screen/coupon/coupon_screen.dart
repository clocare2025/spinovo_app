import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/custom_textfield.dart';
import 'package:spinovo_app/widget/size_box.dart';

// ignore: must_be_immutable
class CouponsScreen extends StatelessWidget {
  CouponsScreen({super.key});

  var coupons = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColors,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Coupons and Offers",
          isBack: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: customTextField(
                controller: coupons,
                hintText: 'Enter coupon code',
              ),
            ),
            const Widths(8),
            Expanded(
              child: ContinueButton(
                text: 'Apply',
                isValid: true,
                isLoading: false,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
