import 'package:flutter/material.dart';
import 'package:spinovo_app/screen/address/address_create_edite_screen.dart';
import 'package:spinovo_app/screen/address/address_create_screen.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class WithoutAddressSection extends StatefulWidget {
  const WithoutAddressSection({super.key});

  @override
  State<WithoutAddressSection> createState() => _WithoutAddressSectionState();
}

class _WithoutAddressSectionState extends State<WithoutAddressSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("asset/images/india_map.png"),
            CustomText(
              text: "We're currently live in select areas of ahmedabad",
              size: 16,
              overFlow: TextOverflow.visible,
              textAlign: TextAlign.center,
              fontweights: FontWeight.w500,
            ),
            const Height(20),
            ContinueButton(
              text: 'Change location',
              isValid: true,
              isLoading: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressCreateEditScreen(),
                  ),
                );
              },
            ),
          ],
        )),
      );
    
  }
}
