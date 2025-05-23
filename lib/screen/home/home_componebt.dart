import 'package:flutter/material.dart';
import 'package:spinovo_app/utiles/designe.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class SpinovoNowSection extends StatelessWidget {
  const SpinovoNowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDesigne.homeScreenBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and subtitle
          Row(
            children: [
              CustomText(
                text: 'Spinovo',
                size: 24,
                fontweights: FontWeight.bold,
              ),
              const Widths(10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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

          Row(
            children: [
              CustomText(
                text: 'Arriving at your doorstep in ',
              ),
              const Icon(
                Icons.bolt,
                color: Colors.pink,
                size: 18,
              ),
              CustomText(
                text: '10 mins',
                color: Colors.pink,
                fontweights: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Booking options with horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 60 mins option
                _buildBookingOption(
                  context,
                  duration: '5 clothes',
                  discountedPrice: '₹169',
                  originalPrice: '₹200',
                  discount: '15% OFF',
                ),
                const SizedBox(width: 16), // Spacing between options
                // 90 clothes option
                _buildBookingOption(
                  context,
                  duration: '10 clothes',
                  discountedPrice: '₹255',
                  originalPrice: '₹300',
                  discount: '15% OFF',
                ),
                const SizedBox(width: 16), // Spacing between options
                _buildBookingOption(
                  context,
                  duration: '10 clothes',
                  discountedPrice: '₹255',
                  originalPrice: '₹300',
                  discount: '15% OFF',
                ),  const SizedBox(width: 16),
                _buildBookingOption(
                  context,
                  duration: '10 clothes',
                  discountedPrice: '₹255',
                  originalPrice: '₹300',
                  discount: '15% OFF',
                ),
                const SizedBox(width: 16),
                _buildBookingOption(
                  context,
                  duration: '10 clothes',
                  discountedPrice: '₹255',
                  originalPrice: '₹300',
                  discount: '15% OFF',
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingOption(
    BuildContext context, {
    required String duration,
    required String discountedPrice,
    required String originalPrice,
    required String discount,
    String itemCount = '',
    bool showButton = true,
  }) {
    return Container(
      width: 125,
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
                text: discount,
                size: 12,
                color: Colors.green,
                fontweights: FontWeight.bold,
              )),
          const Height(8),
          CustomText(
            text: duration,
            size: 16,
            fontweights: FontWeight.bold,
          ),
          const Height(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: discountedPrice,
                size: 16,
                fontweights: FontWeight.bold,
              ),
              const Widths(8),
              CustomText(
                text: originalPrice,
                size: 15,
                // fontweights: FontWeight.w500,
                color: Colors.grey,
                decorationColor: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ],
          ),
          const Height(10),
          Container(
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
          const Height(10),
        ],
      ),
    );
  }
}
