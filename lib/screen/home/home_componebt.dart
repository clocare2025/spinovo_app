// v2

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/package_model.dart';
import 'package:spinovo_app/providers/package_provider.dart';
import 'package:spinovo_app/screen/checkout/package/package_checkout_screen.dart';
import 'package:spinovo_app/utiles/designe.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class SpinovoNowSection extends StatelessWidget {
  const SpinovoNowSection({super.key});

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
                    text: '120 mins',
                    color: Colors.pink,
                    fontweights: FontWeight.bold,
                    size: 12,
                    letterSpacing: 0,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Booking options with horizontal scroll
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: packages.map((package) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildBookingOption(
                        context,
                        package: package,
                        onBook: () {
                          _showPackageDetailsBottomSheet(context, package);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingOption(
    BuildContext context, {
    required Package package,
    required VoidCallback onBook,
  }) {
    var servicList =
        package.services.map((element) => element.serviceName).join(' + ');
    return Container(
      width: 140,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomText(
              text: '${package.discount}% OFF',
              size: 12,
              color: Colors.green,
              fontweights: FontWeight.bold,
            ),
          ),
          const Height(8),
          CustomText(
            text: '${package.noOfClothes} Clothes',
            size: 16,
            fontweights: FontWeight.bold,
          ),
          const Height(5),
          CustomText(
            text: servicList,
            size: 12,
          ),
          const Height(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: '₹${package.discountPrices}',
                size: 16,
                fontweights: FontWeight.bold,
              ),
              const Widths(8),
              CustomText(
                text: '₹${package.originalPrices}',
                size: 15,
                color: Colors.grey,
                decorationColor: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ],
          ),
          const Height(10),
          GestureDetector(
            onTap: onBook,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.pink, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: CustomText(
                text: 'Book',
                color: Colors.pink,
                fontweights: FontWeight.w500,
              ),
            ),
          ),
          const Height(10),
        ],
      ),
    );
  }

  void _showPackageDetailsBottomSheet(BuildContext context, Package package) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.8, // Limit height to 80% of screen
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Package Details',
                        size: 18,
                        fontweights: FontWeight.bold,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Height(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Total Clothes',
                        size: 15,
                        fontweights: FontWeight.bold,
                      ),
                      CustomText(
                        text: "${package.noOfClothes}",
                        size: 15,
                        fontweights: FontWeight.bold,
                      ),
                    ],
                  ),
                  const Height(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Price: ',
                        color: const Color(0xFF525870),
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: '₹${package.discountPrices}',
                            fontweights: FontWeight.bold,
                          ),
                          const Widths(8),
                          CustomText(
                            text: '₹${package.originalPrices}',
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ],
                      )
                    ],
                  ),
                  const Height(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Discount:',
                        color: const Color(0xFF525870),
                      ),
                      CustomText(
                        text: '${package.discount}%',
                      ),
                    ],
                  ),
                  const Height(5),
                  CustomText(
                    text: 'Services Included:',
                    size: 15,
                    fontweights: FontWeight.bold,
                  ),
                  const Height(5),
                  ...package.services.map((service) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text:
                                '${service.serviceName} (${service.clothes} items)',
                            color: const Color(0xFF525870),
                            size: 14,
                          ),
                          // CustomText(
                          //   text: '₹${service.discountPrice}',
                          //   size: 14,
                          // ),
                          Row(
                            children: [
                              CustomText(
                                text: '₹${service.discountPrice}',
                                //   fontweights: FontWeight.bold,
                              ),
                              const Widths(8),
                              CustomText(
                                text: '₹${service.originalPrice}',
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                  const Height(5),
                  // Row(
                  //   children: [
                  //     CustomText(
                  //       text: 'Quick : ',
                  //       size: 15,
                  //       fontweights: FontWeight.bold,
                  //     ),
                  //     CustomText(
                  //       text: 'Service within 2 hours',
                  //       size: 15,

                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     CustomText(
                  //       text: 'Schedule : ',
                  //       size: 15,
                  //       fontweights: FontWeight.bold,
                  //     ),
                  //     CustomText(
                  //       text: 'Service within 24 hours',
                  //       size: 15,

                  //     ),
                  //   ],
                  // ),
                  // const Height(4),
                  // CustomText(
                  //   text:
                  //       'Expert care, eco-friendly cleaning, and doorstep service—fast and professional.',
                  //   overFlow: TextOverflow.visible,
                  //   size: 12,
                  //   color: const Color(0xFF525870),
                  // ),
                  // const Height(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Column(
                      //   children: [
                      //     const Icon(Icons.cleaning_services_outlined,
                      //         color: const Color(0xFF525870), size: 25),
                      //     const Height(5),
                      //     CustomText(
                      //       text: 'Cleaning',
                      //       color: const Color(0xFF525870),
                      //       size: 12,
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                      Column(
                        children: [
                          const Icon(
                            Icons.iron_outlined,
                            size: 25,
                            color: Color(0xFF525870),
                          ),
                          const Height(5),
                          CustomText(
                            text: 'Ironing',
                            color: const Color(0xFF525870),
                            size: 12,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(
                            Icons.dry_cleaning_outlined,
                            size: 25,
                            color: Color(0xFF525870),
                          ),
                          const Height(5),
                          CustomText(
                            text: 'Packaging',
                            color: const Color(0xFF525870),
                            size: 12,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     const Icon(
                      //       Icons.home,
                      //       size: 25,
                      //       color: Color(0xFF525870),
                      //     ),
                      //     const Height(5),
                      //     CustomText(
                      //       text: 'Delivery',
                      //       color: const Color(0xFF525870),
                      //       size: 12,
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),

                  const Height(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ContinueButton(
                          height: 44,
                          text: 'Book Now',
                          textSize: 14,
                          isValid: true,
                          isLoading: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PackageCheckoutScreen(
                                        package: package,
                                      )),
                            );
                            // Navigator.pop(context);
                          },
                        ),
                      ),
                      // const Widths(10),
                      // Expanded(
                      //   child: ContinueButton(
                      //     height: 44,
                      //     text: 'Schedule',
                      //     textSize: 14,
                      //     textColor: const Color.fromARGB(255, 38, 136, 70),
                      //     bgColor: Colors.white,
                      //     border: Border.all(
                      //       color: const Color.fromARGB(255, 38, 136, 70),
                      //     ),
                      //     isValid: true,
                      //     isLoading: false,
                      //     onTap: () {
                      //         Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //                  PackageCheckoutScreen(package: package, )),
                      //       );
                      //       // Navigator.pop(context);
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:spinovo_app/utiles/designe.dart';
// import 'package:spinovo_app/widget/size_box.dart';
// import 'package:spinovo_app/widget/text_widget.dart';

// class SpinovoNowSection extends StatelessWidget {
//   const SpinovoNowSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: AppDesigne.homeScreenBoxDecoration,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title and subtitle
//           Row(
//             children: [
//               CustomText(
//                 text: 'Spinovo',
//                 size: 24,
//                 fontweights: FontWeight.bold,
//               ),
//               const Widths(10),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//                 decoration: const BoxDecoration(
//                   color: Colors.pink,
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(10),
//                       topRight: Radius.circular(10)),
//                 ),
//                 child: CustomText(
//                   text: 'NOW',
//                   size: 9,
//                   fontweights: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),

//           Row(
//             children: [
//               CustomText(
//                 text: 'Arriving at your doorstep in ',
//               ),
//               const Icon(
//                 Icons.bolt,
//                 color: Colors.pink,
//                 size: 18,
//               ),
//               CustomText(
//                 text: '10 mins',
//                 color: Colors.pink,
//                 fontweights: FontWeight.bold,
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           // Booking options with horizontal scroll
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 // 60 mins option
//                 _buildBookingOption(
//                   context,
//                   duration: '5 clothes',
//                   discountedPrice: '₹169',
//                   originalPrice: '₹200',
//                   discount: '15% OFF',
//                 ),
//                 const SizedBox(width: 16), // Spacing between options
//                 // 90 clothes option
//                 _buildBookingOption(
//                   context,
//                   duration: '10 clothes',
//                   discountedPrice: '₹255',
//                   originalPrice: '₹300',
//                   discount: '15% OFF',
//                 ),
//                 const SizedBox(width: 16), // Spacing between options
//                 _buildBookingOption(
//                   context,
//                   duration: '10 clothes',
//                   discountedPrice: '₹255',
//                   originalPrice: '₹300',
//                   discount: '15% OFF',
//                 ),  const SizedBox(width: 16),
//                 _buildBookingOption(
//                   context,
//                   duration: '10 clothes',
//                   discountedPrice: '₹255',
//                   originalPrice: '₹300',
//                   discount: '15% OFF',
//                 ),
//                 const SizedBox(width: 16),
//                 _buildBookingOption(
//                   context,
//                   duration: '10 clothes',
//                   discountedPrice: '₹255',
//                   originalPrice: '₹300',
//                   discount: '15% OFF',
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookingOption(
//     BuildContext context, {
//     required String duration,
//     required String discountedPrice,
//     required String originalPrice,
//     required String discount,
//     String itemCount = '',
//     bool showButton = true,
//   }) {
//     return Container(
//       width: 125,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Container(
//               padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: CustomText(
//                 text: discount,
//                 size: 12,
//                 color: Colors.green,
//                 fontweights: FontWeight.bold,
//               )),
//           const Height(8),
//           CustomText(
//             text: duration,
//             size: 16,
//             fontweights: FontWeight.bold,
//           ),
//           const Height(8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomText(
//                 text: discountedPrice,
//                 size: 16,
//                 fontweights: FontWeight.bold,
//               ),
//               const Widths(8),
//               CustomText(
//                 text: originalPrice,
//                 size: 15,
//                 // fontweights: FontWeight.w500,
//                 color: Colors.grey,
//                 decorationColor: Colors.grey,
//                 decoration: TextDecoration.lineThrough,
//               ),
//             ],
//           ),
//           const Height(10),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.pink, width: 1),
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//             ),
//             child: CustomText(
//               text: 'Book',
//               color: Colors.pink,
//               fontweights: FontWeight.w500,
//             ),
//           ),
//           const Height(10),
//         ],
//       ),
//     );
//   }
// }
