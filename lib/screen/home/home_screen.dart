import 'package:flutter/material.dart';
import 'package:spinovo_app/component/appbar.dart';
import 'package:spinovo_app/component/msgSection.dart';
import 'package:spinovo_app/utiles/assets.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/constants.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppbarComponent(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColor.appbarColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Image.asset('asset/images/van_banner.png'),
                  const Height(10),
                  const ServiceSection(),
                  const Height(20),
                  const BookingTrackingSection(),
                  const Height(30),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: HomeMsgSextion(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class ServiceSection extends StatelessWidget {
  const ServiceSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingText(
              text: 'Our Services',
            ),
            SmallText(
              text: 'All your laundry needs, just a tap away.',
              size: 12,
              letterSpacing: 0,
            ),
            const Height(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppAssets.ironing, height: 80),
                Image.asset(AppAssets.drycleaning, height: 80),
              ],
            ),
            const Height(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppAssets.wash, height: 80),
                Image.asset(AppAssets.washIroning, height: 80),
                Image.asset(AppAssets.shoesCleaning, height: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookingTrackingSection extends StatelessWidget {
  const BookingTrackingSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingText(
              text: 'Ongoing Booking',
            ),
            SmallText(
              text: 'Pickup in 10 minutes',
              size: 12,
              color: Colors.redAccent,
              letterSpacing: 0,
            ),
            const Height(10),
          ],
        ),
      ),
    );
  }
}
