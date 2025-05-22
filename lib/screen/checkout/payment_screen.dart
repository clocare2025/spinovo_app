import 'package:flutter/material.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/utiles/assets.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(
            title: "Payment",
            isBack: true,
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Ironing Service",
                      size: 18,
                      fontweights: FontWeight.w400,
                    ),
                    Height(8),
                    Row(
                      children: [
                        CustomText(
                          text: "Starts at: ",
                          color: Colors.grey,
                        ),
                        CustomText(
                          text: "01:30 pm, 13 May",
                          fontweights: FontWeight.w400,
                        ),
                      ],
                    ),
                    Height(8),
                    Row(
                      children: [
                        CustomText(
                          text: "no of Clothes: ",
                          color: Colors.grey,
                        ),
                        CustomText(
                          text: "10",
                          fontweights: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Height(10),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 0.0),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: 0),
                    leading: Image.asset(
                      AppAssets.offerIcon,
                      color: AppColor.appbarColor,
                      height: 30,
                    ),
                    title: CustomText(
                      text: "Apply coupons or offers",
                      size: 14,
                      fontweights: FontWeight.w500,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_sharp),
                  )),
            ),
            const Height(10),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 0.0),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: 0),
                    leading: Image.asset(
                      AppAssets.walletV2,
                      height: 30,
                      color: AppColor.appbarColor,
                    ),
                    title: CustomText(
                      text: "Redeem using wallet",
                      size: 15,
                      fontweights: FontWeight.w500,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Credit Balance: ",
                          color: Colors.grey,
                        ),
                        CustomText(
                          text: "₹100",
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    trailing: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: AppColor.bgColor, width: 5)),
                    ),
                  )),
            ),
            const Height(10),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Payment Details",
                        size: 16,
                        fontweights: FontWeight.w500,
                      ),
                      const Height(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Service Charge ",
                            color: Colors.grey,
                          ),
                          CustomText(
                            text: "₹150.00",
                            fontweights: FontWeight.w400,
                          ),
                        ],
                      ),
                      const Height(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Slot Charge ",
                            color: Colors.grey,
                          ),
                          CustomText(
                            text: "₹10.00",
                            fontweights: FontWeight.w400,
                          ),
                        ],
                      ),
                      const Height(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(20, (index) {
                          return Container(
                            width: 8,
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 196, 196, 196),
                              // shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                      const Height(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Total Payable ",
                            fontweights: FontWeight.w500,
                          ),
                          CustomText(
                            text: "₹110.00",
                            fontweights: FontWeight.w500,
                          ),
                        ],
                      ),
                      Height(10),
                    ],
                  )),
            ),
            const Height(10),
          ],
        ),
        bottomSheet: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 81, 81, 81).withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: const Offset(0, -2), // Upward shadow
                ),
              ],
            ),
            child: ContinueButton(
              // height: 45,
              text: 'Proceed to Pay ₹123',
              isValid: true,
              isLoading: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentScreen()),
                );
              },
            )));
  }
}
