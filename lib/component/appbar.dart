import 'package:flutter/material.dart';
import 'package:spinovo_app/utiles/constants.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class AppbarComponent extends StatelessWidget {
  const AppbarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorCont.appbarColor,
      ),
      child: const Padding(
        padding: EdgeInsets.only(left: 13, right: 13, top: 30, bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [AddressSection(), WalletSection()],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class WalletSection extends StatelessWidget {
  const WalletSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AssetCont.walletV2,
              color: ColorCont.textColor,
              height: 16,
            ),
            const Widths(6),
            SmallText(
              text: "₹500",
              color: ColorCont.textColor,
              fontweights: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}

class AddressSection extends StatelessWidget {
  const AddressSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.white,
          size: 30,
        ),
        const Widths(5),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallText(
              text: 'Home',
              size: 16,
              fontweights: FontWeight.w500,
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: SmallText(
                    text: '2nd Floor,I hub building, ahmadabad',
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: Colors.white,
                  size: 25,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
