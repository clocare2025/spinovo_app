import 'package:flutter/material.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class GarmentBoxWidget extends StatelessWidget {
  final String name;
  final String quantity;
  final String price;
  final Function add;
  final Function remove;
  final Function addFirstTime;
  final int qty;

  const GarmentBoxWidget(
      {super.key,
      required this.name,
      required this.price,
      required this.add,
      required this.remove,
      required this.quantity,
      required this.qty,
      required this.addFirstTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: const Color(0xFFCEDBF0), width: 1.3),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded ensures text wraps within the available space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Name and price column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                text: name,
                                size: 15,
                                overFlow: TextOverflow.ellipsis,
                                color: Colors.black,
                                fontweights: FontWeight.bold,
                              ),
                              SmallText(
                                text: 'Prices: $price',
                                size: 14,
                                overFlow: TextOverflow.ellipsis,
                                color: Colors.black,
                                fontweights: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        qty > 0
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColor.appbarColor,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 12),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => remove(),
                                      child: const Icon(
                                        Icons.remove_circle_outline_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const Widths(9),
                                    SmallText(
                                      text: quantity,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const Widths(9),
                                    InkWell(
                                      onTap: () => add(),
                                      child: const Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () => addFirstTime(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppColor.appbarColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 9, horizontal: 12),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const Widths(9),
                                      SmallText(
                                        text: 'ADD',
                                        color: Colors.white,
                                        fontweights: FontWeight.bold,
                                        size: 13,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                    const Height(10),
                    SmallText(
                      text:
                          "Shirts, T-shirts, polo shirts, kurtis, blouses, crop tops, casual dresses, skater dresses, trousers, chinos, jeans, pajamas, shorts, leggings, school uniform, tracksuits, joggers, housewear, kids’ casuals",
                      size: 11,
                      color: Colors.black54,
                      overFlow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
