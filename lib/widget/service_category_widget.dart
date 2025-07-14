import 'package:flutter/material.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class CategoryServiceBox extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color bgColor;
  final Color borderColor;
  final int onOfClothe;
  const CategoryServiceBox(
      {super.key,
      required this.title,
      required this.onTap,
      required this.bgColor,
      required this.borderColor,
      required this.onOfClothe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomText(
              text: title,
              fontweights: FontWeight.w500,
            ),
          ),
          if (onOfClothe > 0)
            Positioned(
              left: 0,
              child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: bgColor, width: 1),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: AppColor.blueColor2,
                    //     blurRadius: 4.0,
                    //     spreadRadius: 2.0,
                    //     offset: const Offset(0.0, 0.0),
                    //   )
                    // ],
                  ),
                  child: Center(
                    child: SmallText(
                      text: onOfClothe.toString(),
                      color: Colors.white,
                      size: 10,
                      fontweights: FontWeight.w500,
                    ),
                  )),
            )
        ],
      ),
    );
  }
}

class ServicDetailseBox extends StatelessWidget {
  final String title;
  final String duration;

  const ServicDetailseBox({
    super.key,
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            size: 12,
            color: Colors.black87,
          ),
          const Height(6),
          CustomText(
            text: duration,
            size: 12,
            color: const Color(0xFF33C362),
          ),
        ],
      ),
    );
  }
}
