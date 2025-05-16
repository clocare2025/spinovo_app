import 'package:flutter/material.dart';
import 'package:spinovo_app/component/appbar.dart';
import 'package:spinovo_app/utiles/constants.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorCont.bgColor,
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
                  color: ColorCont.appbarColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  ServiceSection(),
                  Height(10),
                  ServiceSection(),
                  Height(10),
                  ServiceSection(),
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
      height: 300,
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
            )
          ],
        ),
      ),
    );
  }
}
