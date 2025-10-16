// v2

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/package_model.dart';
import 'package:spinovo_app/providers/package_provider.dart';
import 'package:spinovo_app/screen/checkout/package/package_checkout_screen.dart';
import 'package:spinovo_app/screen/checkout/service_category_screen.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/designe.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class SpinovoQuick extends StatelessWidget {
  const SpinovoQuick({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch packages when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PackageProvider>(context, listen: false).fetchPackages();
    });

    return Consumer<PackageProvider>(
      builder: (context, packageProvider, child) {
        if (packageProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (packageProvider.errorMessage != null) {
          return Center(child: Text(packageProvider.errorMessage!));
        }

        final packages = packageProvider.packageModel?.data.packages ?? [];

        if (packages.isEmpty) {
          return const Center(child: Text('No packages available'));
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDesigne.homeScreenBoxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and subtitle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      HeadingText(
                        text: 'Spinovo Quick',
                        size: 20,
                      ),
                      // CustomText(
                      //   text: 'Spinovo Express',
                      //   size: 24,
                      //   fontweights: FontWeight.bold,
                      // ),
                      const Widths(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: CustomText(
                          text: 'NOW',
                          size: 9,
                          fontweights: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Lottie.asset('asset/icons/delivery_copilot.json',
                      height: 30, frameRate: FrameRate(1000))
                ],
              ),
              Row(
                children: [
                  SmallText(
                    text: 'Delivered to your doorstep within ',
                    size: 12,
                    letterSpacing: 0,
                  ),
                  const Icon(
                    Icons.bolt,
                    color: Colors.pink,
                    size: 16,
                  ),
                  SmallText(
                    text: '2 hours',
                    color: Colors.pink,
                    fontweights: FontWeight.bold,
                    size: 12,
                    letterSpacing: 0,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildBookingOption(
                context,
                onBook: () {
                  // _showPackageDetailsBottomSheet(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceCategoryScreen(
                        serviceId: 0,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingOption(
    BuildContext context, {
    required VoidCallback onBook,
  }) {
    // var servicList =
    //     package.services.map((element) => element.serviceName).join(' + ');
    return Container(
      // width: 240,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: onBook,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration:  BoxDecoration(
            color: const Color.fromARGB(107, 91, 202, 128),
            // color: Color.fromARGB(248, 45, 165, 85),
            border: Border.all(
              // color: Colors.pink,
              color: AppColor.appbarColor,
               width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: CustomText(
              text: 'Order Now',
              size: 15,
              // color: Colors.pink,
              color: const Color.fromARGB(248, 39, 164, 81),
              fontweights: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

}
