import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/screen/address/address_screen.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class AppBarCheckout extends StatelessWidget {
  final String? addressId;
  const AppBarCheckout({super.key, this.addressId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        final defaultAddress = addressProvider.addresses.firstWhere(
          (address) => address.isPrimary == true,
          orElse: () => addressProvider.addresses.isNotEmpty
              ? addressProvider.addresses.first
              : AddressData(formatAddress: 'Select Address'),
        );

        // Truncate address to fit in app bar (max 30 characters)
        final displayAddress = defaultAddress.formatAddress != null &&
                defaultAddress.formatAddress!.length > 30
            ? '${defaultAddress.formatAddress!.substring(0, 27)}...'
            : defaultAddress.formatAddress ?? 'Select Address';

        return AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColor.textColor),
            onPressed: () => context.pop(),
          ),
          title: CustomText(
            text: displayAddress,
            size: 15,
            // fontweights: FontWeight.w500,
            color: AppColor.textColor,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddressScreen(selectedAddressId: addressId),
                  ),
                );
              },
              child: CustomText(
                text: displayAddress == 'Select Address' ? "Select" : "Change",
                size: 15,
                color: AppColor.appbarColor,
                // fontweights: FontWeight.w600,
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:spinovo_app/screen/address/address_screen.dart';
// import 'package:spinovo_app/utiles/color.dart';
// import 'package:spinovo_app/widget/text_widget.dart';

// class AppBarCheckout extends StatelessWidget {
//   const AppBarCheckout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back, color: AppColor.textColor),
//         onPressed: () => context.pop(),
//       ),
//       title: CustomText(
//         text: "Home | i-hub Gujrat",
//         size: 15,
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const AddressScreen()),
//             );
//           },
//           child: CustomText(
//             text: "Change",
//             size: 15,
//             color: AppColor.appbarColor,
//           ),
//         ),
//       ],
//       backgroundColor: Colors.white,
//       elevation: 0,
//     );
//   }
// }
