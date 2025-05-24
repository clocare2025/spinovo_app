import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/component/home_appbar.dart';
import 'package:spinovo_app/component/msgSection.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/screen/checkout/checkout_screen.dart';
import 'package:spinovo_app/screen/home/home_componebt.dart';
import 'package:spinovo_app/utiles/assets.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/designe.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    // Fetch addresses when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    });
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('asset/images/van_banner.png'),
                  const Height(10),
                  const SpinovoNowSection(),
                  const Height(20),
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

  void _serviceTap(int serviceId, context) {
    print(serviceId);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CheckoutScreen(
                serviceId: '1',
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      width: double.infinity,
      decoration: AppDesigne.homeScreenBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
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
              ],
            ),
          ),
          const Height(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceBox(
                title: 'Ironing',
                id: 1,
                image: AppAssets.ironing,
                onTap: () {
                  _serviceTap(1, context);
                },
              ),
              ServiceBox(
                title: 'Dry Cleaning',
                id: 4,
                image: AppAssets.drycleaning,
                onTap: () {
                  _serviceTap(4, context);
                },
              ),
            ],
          ),
          const Height(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceBox(
                title: 'Wash',
                id: 2,
                image: AppAssets.wash,
                onTap: () {
                  _serviceTap(2, context);
                },
              ),
              ServiceBox(
                title: 'Wash + Ironing',
                id: 3,
                image: AppAssets.washIroning,
                onTap: () {
                  _serviceTap(3, context);
                },
              ),
              ServiceBox(
                title: 'Shoe Cleaning',
                id: 5,
                image: AppAssets.shoesCleaning,
                onTap: () {
                  _serviceTap(5, context);
                },
              ),
            ],
          ),
          const Height(20),
        ],
      ),
    );
  }
}

class ServiceBox extends StatelessWidget {
  final String title;
  final int id;
  final Function onTap;
  final String image;
  const ServiceBox({
    super.key,
    required this.title,
    required this.id,
    required this.onTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Image.asset(image, height: 85));
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
      decoration: AppDesigne.homeScreenBoxDecoration,
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
