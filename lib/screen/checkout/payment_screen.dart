import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/providers/wallet_provider.dart';
import 'package:spinovo_app/razorpay/payment_utils.dart';
import 'package:spinovo_app/screen/address/address_screen.dart';
import 'package:spinovo_app/screen/coupon/coupon_screen.dart';
import 'package:spinovo_app/utiles/assets.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/dot_point_widget.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;
  const PaymentScreen({super.key, required this.bookingDetails});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedTip = 0;
  late PaymentUtils _paymentUtils;
  bool _useWallet = false;
  bool _isNavigating = false; // Prevent multiple navigations
  DateTime? _lastToastTime; // Debounce toast
  bool _isProcessing = false; // Prevent multiple payment attempts

  @override
  void initState() {
    super.initState();
    _paymentUtils = PaymentUtils();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletProvider>(context, listen: false).fetchBalance();
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    });
  }

  @override
  void dispose() {
    _paymentUtils.dispose();
    super.dispose();
  }

  // Debounced toast to prevent overlap
  void _showToast(String message) {
    final now = DateTime.now();
    if (_lastToastTime == null ||
        now.difference(_lastToastTime!).inMilliseconds > 2000) {
      showToast(message);
      _lastToastTime = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Provider.of<WalletProvider>(context)),
        ChangeNotifierProvider.value(
            value: Provider.of<AddressProvider>(context)),
      ],
      child: Consumer2<WalletProvider, AddressProvider>(
        builder: (context, walletProvider, addressProvider, child) {
          final walletBalance = walletProvider
                  .walletBalance?.data?.wallet?.totalBalance
                  ?.toInt() ??
              0;
          final defaultAddress = addressProvider.addresses.firstWhere(
            (address) => address.isPrimary == true,
            orElse: () => addressProvider.addresses.isNotEmpty
                ? addressProvider.addresses.first
                : AddressData(
                    addressId: null, formatAddress: 'No address available'),
          );
          final charges = {
            'service_charge':
                widget.bookingDetails['service_charges'] as int? ?? 0,
            'slot_charge': widget.bookingDetails['slot_charges'] as int? ?? 0,
            'tips': _selectedTip,
          };
          final totalPayable = charges.values.reduce((a, b) => a + b);
          final payableAfterWallet = _useWallet
              ? (totalPayable > walletBalance
                  ? totalPayable - walletBalance
                  : 0)
              : totalPayable;

          return Scaffold(
            backgroundColor: AppColor.bgColor,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: CustomAppBar(title: "Payment", isBack: true),
            ),
            body: walletProvider.isLoading || addressProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : walletProvider.errorMessage != null ||
                        addressProvider.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: walletProvider.errorMessage ??
                                  addressProvider.errorMessage!,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                walletProvider.fetchBalance();
                                addressProvider.fetchAddresses();
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildBookingDetails(defaultAddress),
                            const Height(8),
                            _buildCouponsSection(),
                            const Height(8),
                            _buildWalletSection(walletBalance),
                            const Height(8),
                            _buildTipsSection(),
                            const Height(8),
                            _buildPaymentDetails(charges, totalPayable),
                            const Height(200),
                          ],
                        ),
                      ),
            bottomSheet: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 81, 81, 81).withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ContinueButton(
                text: payableAfterWallet > 0
                    ? 'Pay ₹$payableAfterWallet'
                    : 'Confirm Booking',
                isValid: defaultAddress.addressId != null && !_isProcessing,
                isLoading: walletProvider.isLoading ||
                    addressProvider.isLoading ||
                    _isProcessing,
                onTap: () {
                  if (_isNavigating || _isProcessing) return;
                  if (defaultAddress.addressId == null) {
                    _showToast('Please select an address');
                    _isNavigating = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddressScreen(
                            selectedAddressId: defaultAddress.addressId),
                      ),
                    ).then((_) => _isNavigating = false);
                    return;
                  }
                  _processPayment(
                      walletBalance, totalPayable, defaultAddress.addressId!);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingDetails(AddressData defaultAddress) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: widget.bookingDetails['service_name'] ?? 'Service',
              size: 18,
              fontweights: FontWeight.w400,
            ),
            const Height(8),
            Row(
              children: [
                CustomText(text: "Starts at: ", color: Colors.grey),
                CustomText(
                  text:
                      "${widget.bookingDetails['booking_time']}, ${widget.bookingDetails['booking_date']}",
                  fontweights: FontWeight.w400,
                ),
              ],
            ),
            const Height(8),
            Row(
              children: [
                CustomText(text: "No. of Clothes: ", color: Colors.grey),
                CustomText(
                  text: "${widget.bookingDetails['garment_qty']}",
                  fontweights: FontWeight.w400,
                ),
              ],
            ),
            const Height(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Address: ", color: Colors.grey),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_isNavigating) return;
                      _isNavigating = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddressScreen(
                              selectedAddressId: defaultAddress.addressId),
                        ),
                      ).then((_) => _isNavigating = false);
                    },
                    child: CustomText(
                      text: defaultAddress.formatAddress ?? 'Select an address',
                      color: defaultAddress.addressId == null
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponsSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
          leading: Image.asset(AppAssets.offerIcon, height: 30),
          title: CustomText(
            text: "Apply coupons or offers",
            size: 14,
            fontweights: FontWeight.w500,
          ),
          trailing: const Icon(Icons.arrow_forward_ios_sharp),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CouponsScreen()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWalletSection(int walletBalance) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
          leading: Image.asset(AppAssets.walletV2,
              height: 30, color: AppColor.appbarColor),
          title: CustomText(
            text: "Redeem using wallet",
            size: 15,
            fontweights: FontWeight.w500,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Credit Balance: ", color: Colors.grey),
              CustomText(text: "₹$walletBalance", color: Colors.grey),
            ],
          ),
          trailing: Checkbox(
            value: _useWallet,
            onChanged: walletBalance > 0
                ? (value) {
                    setState(() {
                      _useWallet = value ?? false;
                    });
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    final tipOptions = [10, 20, 30, 50];
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Tip your co-pilot partner",
                  size: 16,
                  fontweights: FontWeight.w500,
                ),
                Lottie.asset('asset/icons/delivery_copilot.json', height: 30)
              ],
            ),
            const Height(3),
            CustomText(
              text:
                  "Your tip goes 100% to the partner who provided quick laundry and ironing service at your doorstep.",
              overFlow: TextOverflow.visible,
              size: 10,
            ),
            const Height(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: tipOptions.map((tip) {
                final isSelected = _selectedTip == tip;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTip = isSelected ? 0 : tip;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFFE9FFEB) : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF33C362)
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText(
                      text: "₹$tip",
                      fontweights:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails(Map<String, int> charges, int totalPayable) {
    final originalAmount =
        widget.bookingDetails['garment_original_amount'] as int? ?? 0;
    final discountedAmount =
        widget.bookingDetails['garment_discount_amount'] as int? ?? 0;
    final discount = originalAmount - discountedAmount;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Billing Details",
              size: 16,
              fontweights: FontWeight.w500,
            ),
            const Height(10),
            _buildChargeRow("Original Amount", originalAmount),
            if (discount > 0) ...[
              const Height(10),
              _buildChargeRow("Discount", -discount, color: Colors.green),
            ],
            // const Height(10),
            // _buildChargeRow("Service Charge", charges['service_charge']!),
            const Height(10),
            _buildChargeRow("Slot Charge", charges['slot_charge']!),
            if (charges['tips']! > 0) ...[
              const Height(10),
              _buildChargeRow("Tip", charges['tips']!),
            ],
            const Height(10),
            const dotPointWidget(),
            const Height(10),
            _buildChargeRow("Total Payable", totalPayable, isTotal: true),
            const Height(10),
          ],
        ),
      ),
    );
  }

  Widget _buildChargeRow(String title, int amount,
      {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontweights: isTotal ? FontWeight.w500 : FontWeight.normal,
          color: color ?? (isTotal ? Colors.black : Colors.grey),
        ),
        CustomText(
          text: amount < 0 ? "-₹${-amount}.00" : "₹${amount}.00",
          fontweights: isTotal ? FontWeight.w500 : FontWeight.w400,
          color: color ?? Colors.black,
        ),
      ],
    );
  }

  void _processPayment(
      int walletBalance, int totalPayable, String addressId) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    // Validate inputs
    if (totalPayable <= 0) {
      _showToast('Invalid payment amount');
      setState(() {
        _isProcessing = false;
      });
      return;
    }
    if (_useWallet && walletBalance < 0) {
      _showToast('Invalid wallet balance');
      setState(() {
        _isProcessing = false;
      });
      return;
    }
    if (widget.bookingDetails['service_id'] == null ||
        widget.bookingDetails['garment_qty'] == null) {
      _showToast('Invalid booking details');
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    final bookingDetails = Map<String, dynamic>.from(widget.bookingDetails);
    bookingDetails['address_id'] = addressId;

    try {
      await _paymentUtils.processPayment(
        context: context,
        bookingDetails: bookingDetails,
        totalPayable: totalPayable,
        walletBalance: _useWallet ? walletBalance : 0,
        tipsAmount: _selectedTip,
        addressId: addressId,
        onSuccess: () {
          _showToast('Payment successful');
          Navigator.pushNamed(context, '/bookings');
        },
        onError: (error) {
          String errorMessage;
          if (error.contains('ExternalWalletSelectedException')) {
            errorMessage = 'External wallet payment cancelled';
          } else if (error.contains('NetworkError')) {
            errorMessage = 'Network error, please check your connection';
          } else if (error.contains('Validation error')) {
            errorMessage = 'Invalid payment details, please try again';
          } else {
            errorMessage = 'Payment failed: $error';
          }
          _showToast(errorMessage);
        },
      );
    } catch (e) {
      _showToast('Unexpected error: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}




// v3

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:spinovo_app/component/custom_appbar.dart';
// import 'package:spinovo_app/models/address_model.dart';
// import 'package:spinovo_app/providers/address_provider.dart';
// import 'package:spinovo_app/providers/wallet_provider.dart';
// import 'package:spinovo_app/razorpay/payment_utils.dart';
// import 'package:spinovo_app/utiles/assets.dart';
// import 'package:spinovo_app/utiles/color.dart';
// import 'package:spinovo_app/utiles/toast.dart';

// import 'package:spinovo_app/widget/button.dart';
// import 'package:spinovo_app/widget/size_box.dart';
// import 'package:spinovo_app/widget/text_widget.dart';

// class PaymentScreen extends StatefulWidget {
//   final Map<String, dynamic> bookingDetails;
//   const PaymentScreen({super.key, required this.bookingDetails});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   int _selectedTip = 0;
//   late PaymentUtils _paymentUtils;
//   bool _useWallet = false;
//   bool _isNavigating = false; // Prevent multiple navigations
//   DateTime? _lastToastTime; // Debounce toast

//   @override
//   void initState() {
//     super.initState();
//     _paymentUtils = PaymentUtils();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<WalletProvider>(context, listen: false).fetchBalance();
//       Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
//     });
//   }

//   @override
//   void dispose() {
//     _paymentUtils.dispose();
//     super.dispose();
//   }

//   // Debounced toast to prevent overlap
//   void _showToast(String message) {
//     final now = DateTime.now();
//     if (_lastToastTime == null || now.difference(_lastToastTime!).inMilliseconds > 2000) {
//       showToast(message);
//       _lastToastTime = now;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider.value(value: Provider.of<WalletProvider>(context)),
//         ChangeNotifierProvider.value(value: Provider.of<AddressProvider>(context)),
//       ],
//       child: Consumer2<WalletProvider, AddressProvider>(
//         builder: (context, walletProvider, addressProvider, child) {
//           final walletBalance = walletProvider.walletBalance?.data?.wallet?.totalBalance?.toDouble() ?? 0.0;
//           final defaultAddress = addressProvider.addresses.firstWhere(
//             (address) => address.isPrimary == true,
//             orElse: () => addressProvider.addresses.isNotEmpty
//                 ? addressProvider.addresses.first
//                 : AddressData(addressId: null, formatAddress: 'No address available'),
//           );
//           final charges = {
//             'service_charge': widget.bookingDetails['service_charges']?.toDouble() ?? 0.0,
//             'slot_charge': widget.bookingDetails['slot_charges']?.toDouble() ?? 0.0,
//             'tips': _selectedTip.toDouble(),
//           };
//           final totalPayable = charges.values.reduce((a, b) => a + b);
//           final payableAfterWallet = _useWallet
//               ? (totalPayable > walletBalance ? totalPayable - walletBalance : 0.0)
//               : totalPayable;

//           return Scaffold(
//             backgroundColor: AppColor.bgColor,
//             appBar: const PreferredSize(
//               preferredSize: Size.fromHeight(60),
//               child: CustomAppBar(title: "Payment", isBack: true),
//             ),
//             body: walletProvider.isLoading || addressProvider.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : walletProvider.errorMessage != null || addressProvider.errorMessage != null
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomText(
//                               text: walletProvider.errorMessage ?? addressProvider.errorMessage!,
//                               color: Colors.red,
//                             ),
//                             const SizedBox(height: 16),
//                             ElevatedButton(
//                               onPressed: () {
//                                 walletProvider.fetchBalance();
//                                 addressProvider.fetchAddresses();
//                               },
//                               child: const Text("Retry"),
//                             ),
//                           ],
//                         ),
//                       )
//                     : SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             _buildBookingDetails(defaultAddress),
//                             const Height(8),
//                             _buildCouponsSection(),
//                             const Height(8),
//                             _buildWalletSection(walletBalance),
//                             const Height(8),
//                             _buildTipsSection(),
//                             const Height(8),
//                             _buildPaymentDetails(charges, totalPayable),
//                             const Height(10),
//                           ],
//                         ),
//                       ),
//             bottomSheet: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color.fromARGB(255, 81, 81, 81).withOpacity(0.1),
//                     blurRadius: 4,
//                     spreadRadius: 2,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: ContinueButton(
//                 text: payableAfterWallet > 0
//                     ? 'Pay ₹${payableAfterWallet.toStringAsFixed(2)}'
//                     : 'Confirm Booking',
//                 isValid: defaultAddress.addressId != null,
//                 isLoading: walletProvider.isLoading || addressProvider.isLoading,
//                 onTap: () {
//                   print(defaultAddress.addressId );
//                   if (_isNavigating) return; // Prevent multiple clicks
//                   if (defaultAddress.addressId == null) {
//                     _showToast('Please select an address');
//                     _isNavigating = true;
//                     // context.go('/address').then((_) => _isNavigating = false);
//                     return;
//                   }
//                   _processPayment(walletBalance, totalPayable, defaultAddress.addressId!);
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildBookingDetails(AddressData defaultAddress) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText(
//               text: widget.bookingDetails['service_name'] ?? 'Service',
//               size: 18,
//               fontweights: FontWeight.w400,
//             ),
//             const Height(8),
//             Row(
//               children: [
//                  CustomText(text: "Starts at: ", color: Colors.grey),
//                 CustomText(
//                   text: "${widget.bookingDetails['booking_time']}, ${widget.bookingDetails['booking_date']}",
//                   fontweights: FontWeight.w400,
//                 ),
//               ],
//             ),
//             const Height(8),
//             Row(
//               children: [
//                  CustomText(text: "No. of Clothes: ", color: Colors.grey),
//                 CustomText(
//                   text: "${widget.bookingDetails['garment_qty']}",
//                   fontweights: FontWeight.w400,
//                 ),
//               ],
//             ),
//             const Height(8),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                  CustomText(text: "Address: ", color: Colors.grey),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       if (_isNavigating) return;
//                       _isNavigating = true;
//                       // context.go('/address?addressId=${defaultAddress.addressId}').then((_) => _isNavigating = false);
//                     },
//                     child: CustomText(
//                       text: defaultAddress.formatAddress ?? 'Select an address',
//                       fontweights: FontWeight.w400,
//                       color: defaultAddress.addressId == null ? Colors.red : Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCouponsSection() {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         child: ListTile(
//           dense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
//           visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
//           leading: Image.asset(AppAssets.offerIcon, height: 30),
//           title:  CustomText(
//             text: "Apply coupons or offers",
//             size: 14,
//             fontweights: FontWeight.w500,
//           ),
//           trailing: const Icon(Icons.arrow_forward_ios_sharp),
//           onTap: () => _showToast('Coupon feature coming soon'),
//         ),
//       ),
//     );
//   }

//   Widget _buildWalletSection(double walletBalance) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         child: ListTile(
//           dense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
//           visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
//           leading: Image.asset(AppAssets.walletV2, height: 30, color: AppColor.appbarColor),
//           title:  CustomText(
//             text: "Redeem using wallet",
//             size: 15,
//             fontweights: FontWeight.w500,
//           ),
//           subtitle: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                CustomText(text: "Credit Balance: ", color: Colors.grey),
//               CustomText(text: "₹${walletBalance.toStringAsFixed(2)}", color: Colors.grey),
//             ],
//           ),
//           trailing: Checkbox(
//             value: _useWallet,
//             onChanged: walletBalance > 0
//                 ? (value) {
//                     setState(() {
//                       _useWallet = value ?? false;
//                     });
//                   }
//                 : null,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTipsSection() {
//     final tipOptions = [10, 20, 30, 50];
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//              CustomText(
//               text: "Add a Tip (Optional)",
//               size: 16,
//               fontweights: FontWeight.w500,
//             ),
//             const Height(10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: tipOptions.map((tip) {
//                 final isSelected = _selectedTip == tip;
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedTip = isSelected ? 0 : tip;
//                     });
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(right: 10),
//                     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: isSelected ? const Color(0xFFE9FFEB) : Colors.white,
//                       border: Border.all(
//                         color: isSelected ? const Color(0xFF33C362) : Colors.grey[300]!,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: CustomText(
//                       text: "₹$tip",
//                       fontweights: isSelected ? FontWeight.w500 : FontWeight.normal,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentDetails(Map<String, dynamic> charges, double totalPayable) {
//     final originalAmount = widget.bookingDetails['garment_original_amount']?.toDouble() ?? 0.0;
//     final discountedAmount = widget.bookingDetails['garment_discount_amount']?.toDouble() ?? 0.0;
//     final discount = originalAmount - discountedAmount;

//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//              CustomText(
//               text: "Billing Details",
//               size: 16,
//               fontweights: FontWeight.w500,
//             ),
//             const Height(10),
//             _buildChargeRow("Original Amount", originalAmount),
//             if (discount > 0) ...[
//               const Height(10),
//               _buildChargeRow("Discount", -discount, color: Colors.green),
//             ],
//             const Height(10),
//             _buildChargeRow("Service Charge", charges['service_charge']!),
//             const Height(10),
//             _buildChargeRow("Slot Charge", charges['slot_charge']!),
//             if (charges['tips']! > 0) ...[
//               const Height(10),
//               _buildChargeRow("Tip", charges['tips']!),
//             ],
//             const Height(10),
//             const Divider(color: Colors.grey),
//             const Height(10),
//             _buildChargeRow("Total Payable", totalPayable, isTotal: true),
//             const Height(10),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChargeRow(String title, double amount, {bool isTotal = false, Color? color}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CustomText(
//           text: title,
//           fontweights: isTotal ? FontWeight.w500 : FontWeight.normal,
//           color: color ?? (isTotal ? Colors.black : Colors.grey),
//         ),
//         CustomText(
//           text: amount < 0 ? "-₹${(-amount).toStringAsFixed(2)}" : "₹${amount.toStringAsFixed(2)}",
//           fontweights: isTotal ? FontWeight.w500 : FontWeight.w400,
//           color: color ?? Colors.black,
//         ),
//       ],
//     );
//   }

//   void _processPayment(double walletBalance, double totalPayable, String addressId) {
//     final bookingDetails = Map<String, dynamic>.from(widget.bookingDetails);
//     bookingDetails['address_id'] = addressId;
//     _paymentUtils.processPayment(
//       context: context,
//       bookingDetails: bookingDetails,
//       totalPayable: totalPayable,
//       walletBalance: _useWallet ? walletBalance : 0.0,
//       tipsAmount: _selectedTip,
//       addressId: addressId,
//       onSuccess: () {
//         _showToast('Payment successful');
//         context.go('/bookings');
//       },
//       onError: (error) {
//         _showToast('Payment failed: $error');
//       },
//     );
//   }
// }


// v2

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:spinovo_app/component/custom_appbar.dart';
// import 'package:spinovo_app/models/address_model.dart';
// import 'package:spinovo_app/providers/address_provider.dart';
// import 'package:spinovo_app/providers/wallet_provider.dart';
// import 'package:spinovo_app/razorpay/payment_utils.dart';
// import 'package:spinovo_app/utiles/assets.dart';
// import 'package:spinovo_app/utiles/color.dart';
// import 'package:spinovo_app/utiles/toast.dart';
// import 'package:spinovo_app/widget/button.dart';
// import 'package:spinovo_app/widget/size_box.dart';
// import 'package:spinovo_app/widget/text_widget.dart';

// class PaymentScreen extends StatefulWidget {
//   final Map<String, dynamic> bookingDetails;
//   const PaymentScreen({super.key, required this.bookingDetails});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   int _selectedTip = 0;
//   late PaymentUtils _paymentUtils;
//   bool _useWallet = false;

//   @override
//   void initState() {
//     super.initState();
//     _paymentUtils = PaymentUtils();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<WalletProvider>(context, listen: false).fetchBalance();
//       Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
//     });
//   }

//   @override
//   void dispose() {
//     _paymentUtils.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider.value(value: Provider.of<WalletProvider>(context)),
//         ChangeNotifierProvider.value(value: Provider.of<AddressProvider>(context)),
//       ],
//       child: Consumer2<WalletProvider, AddressProvider>(
//         builder: (context, walletProvider, addressProvider, child) {
//           final walletBalance = walletProvider.walletBalance?.data?.wallet?.totalBalance?.toDouble() ?? 0.0;
//           final defaultAddress = addressProvider.addresses.firstWhere(
//             (address) => address.isPrimary == true,
//             orElse: () => addressProvider.addresses.isNotEmpty
//                 ? addressProvider.addresses.first
//                 : AddressData(formatAddress: 'No address available'),
//           );
//           final charges = {
//             'service_charge': widget.bookingDetails['service_charges']?.toDouble() ?? 0.0,
//             'slot_charge': widget.bookingDetails['slot_charges']?.toDouble() ?? 0.0,
//             'tips': _selectedTip.toDouble(),
//           };
//           final totalPayable = charges.values.reduce((a, b) => a + b);
//           final payableAfterWallet = _useWallet
//               ? (totalPayable > walletBalance ? totalPayable - walletBalance : 0.0)
//               : totalPayable;

//           return Scaffold(
//             backgroundColor: AppColor.bgColor,
//             appBar: const PreferredSize(
//               preferredSize: Size.fromHeight(60),
//               child: CustomAppBar(title: "Payment", isBack: true),
//             ),
//             body: walletProvider.isLoading || addressProvider.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : walletProvider.errorMessage != null || addressProvider.errorMessage != null
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomText(
//                               text: walletProvider.errorMessage ?? addressProvider.errorMessage!,
//                               color: Colors.red,
//                             ),
//                             const SizedBox(height: 16),
//                             ElevatedButton(
//                               onPressed: () {
//                                 walletProvider.fetchBalance();
//                                 addressProvider.fetchAddresses();
//                               },
//                               child: const Text("Retry"),
//                             ),
//                           ],
//                         ),
//                       )
//                     : SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             _buildBookingDetails(defaultAddress),
//                             const Height(8),
//                             _buildCouponsSection(),
//                             const Height(8),
//                             _buildWalletSection(walletBalance),
//                             const Height(8),
//                             _buildTipsSection(),
//                             const Height(8),
//                             _buildPaymentDetails(charges, totalPayable),
//                             const Height(10),
//                           ],
//                         ),
//                       ),
//             bottomSheet: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color.fromARGB(255, 81, 81, 81).withOpacity(0.1),
//                     blurRadius: 4,
//                     spreadRadius: 2,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: ContinueButton(
//                 text: payableAfterWallet > 0
//                     ? 'Pay ₹${payableAfterWallet.toStringAsFixed(2)}'
//                     : 'Confirm Booking',
//                 isValid: defaultAddress.addressId != null,
//                 isLoading: walletProvider.isLoading || addressProvider.isLoading,
//                 onTap: defaultAddress.addressId == null
//                     ? () {
//                         showToast('Please select an address');
//                         context.go('/address');
//                       }
//                     : () => _processPayment(walletBalance, totalPayable, defaultAddress.addressId!),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildBookingDetails(AddressData defaultAddress) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText(
//               text: widget.bookingDetails['service_name'] ?? 'Service',
//               size: 18,
//               fontweights: FontWeight.w400,
//             ),
//             const Height(8),
//             Row(
//               children: [
//                  CustomText(text: "Starts at: ", color: Colors.grey),
//                 CustomText(
//                   text: "${widget.bookingDetails['booking_time']}, ${widget.bookingDetails['booking_date']}",
//                   fontweights: FontWeight.w400,
//                 ),
//               ],
//             ),
//             const Height(8),
//             Row(
//               children: [
//                  CustomText(text: "No. of Clothes: ", color: Colors.grey),
//                 CustomText(
//                   text: "${widget.bookingDetails['garment_qty']}",
//                   fontweights: FontWeight.w400,
//                 ),
//               ],
//             ),
//             const Height(8),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                  CustomText(text: "Address: ", color: Colors.grey),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       context.go('/address?addressId=${defaultAddress.addressId}');
//                     },
//                     child: CustomText(
//                       text: defaultAddress.formatAddress ?? 'Select an address',
//                       fontweights: FontWeight.w400,
//                       color: defaultAddress.addressId == null ? Colors.red : Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCouponsSection() {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         child: ListTile(
//           dense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
//           visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
//           leading: Image.asset(AppAssets.offerIcon, height: 30),
//           title:  CustomText(
//             text: "Apply coupons or offers",
//             size: 14,
//             fontweights: FontWeight.w500,
//           ),
//           trailing: const Icon(Icons.arrow_forward_ios_sharp),
//           onTap: () => showToast('Coupon feature coming soon'),
//         ),
//       ),
//     );
//   }

//   Widget _buildWalletSection(double walletBalance) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         child: ListTile(
//           dense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
//           visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
//           leading: Image.asset(AppAssets.walletV2, height: 30, color: AppColor.appbarColor),
//           title:  CustomText(
//             text: "Redeem using wallet",
//             size: 15,
//             fontweights: FontWeight.w500,
//           ),
//           subtitle: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                CustomText(text: "Credit Balance: ", color: Colors.grey),
//               CustomText(text: "₹${walletBalance.toStringAsFixed(2)}", color: Colors.grey),
//             ],
//           ),
//           trailing: Checkbox(
//             value: _useWallet,
//             onChanged: walletBalance > 0
//                 ? (value) {
//                     setState(() {
//                       _useWallet = value ?? false;
//                     });
//                   }
//                 : null,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTipsSection() {
//     final tipOptions = [10, 20, 30, 50];
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//              CustomText(
//               text: "Add a Tip (Optional)",
//               size: 16,
//               fontweights: FontWeight.w500,
//             ),
//             const Height(10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: tipOptions.map((tip) {
//                 final isSelected = _selectedTip == tip;
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedTip = isSelected ? 0 : tip;
//                     });
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(right: 10),
//                     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: isSelected ? const Color(0xFFE9FFEB) : Colors.white,
//                       border: Border.all(
//                         color: isSelected ? const Color(0xFF33C362) : Colors.grey[300]!,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: CustomText(
//                       text: "₹$tip",
//                       fontweights: isSelected ? FontWeight.w500 : FontWeight.normal,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentDetails(Map<String, dynamic> charges, double totalPayable) {
//     final originalAmount = widget.bookingDetails['garment_original_amount']?.toDouble() ?? 0.0;
//     final discountedAmount = widget.bookingDetails['garment_discount_amount']?.toDouble() ?? 0.0;
//     final discount = originalAmount - discountedAmount;

//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//              CustomText(
//               text: "Billing Details",
//               size: 16,
//               fontweights: FontWeight.w500,
//             ),
//             const Height(10),
//             _buildChargeRow("Original Amount", originalAmount),
//             if (discount > 0) ...[
//               const Height(10),
//               _buildChargeRow("Discount", -discount, color: Colors.green),
//             ],
//             const Height(10),
//             _buildChargeRow("Service Charge", charges['service_charge']!),
//             const Height(10),
//             _buildChargeRow("Slot Charge", charges['slot_charge']!),
//             if (charges['tips']! > 0) ...[
//               const Height(10),
//               _buildChargeRow("Tip", charges['tips']!),
//             ],
//             const Height(10),
//             const Divider(color: Colors.grey),
//             const Height(10),
//             _buildChargeRow("Total Payable", totalPayable, isTotal: true),
//             const Height(10),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChargeRow(String title, double amount, {bool isTotal = false, Color? color}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CustomText(
//           text: title,
//           fontweights: isTotal ? FontWeight.w500 : FontWeight.normal,
//           color: color ?? (isTotal ? Colors.black : Colors.grey),
//         ),
//         CustomText(
//           text: amount < 0 ? "-₹${(-amount).toStringAsFixed(2)}" : "₹${amount.toStringAsFixed(2)}",
//           fontweights: isTotal ? FontWeight.w500 : FontWeight.w400,
//           color: color ?? Colors.black,
//         ),
//       ],
//     );
//   }

//   void _processPayment(double walletBalance, double totalPayable, String addressId) {
//     final bookingDetails = Map<String, dynamic>.from(widget.bookingDetails);
//     bookingDetails['address_id'] = addressId;
//     _paymentUtils.processPayment(
//       context: context,
//       bookingDetails: bookingDetails,
//       totalPayable: totalPayable,
//       walletBalance: _useWallet ? walletBalance : 0.0,
//       tipsAmount: _selectedTip,
//       addressId: addressId,
//       onSuccess: () {
//         context.go('/bookings');
//       },
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:spinovo_app/component/custom_appbar.dart';
// import 'package:spinovo_app/utiles/assets.dart';
// import 'package:spinovo_app/utiles/color.dart';
// import 'package:spinovo_app/widget/button.dart';
// import 'package:spinovo_app/widget/size_box.dart';
// import 'package:spinovo_app/widget/text_widget.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: AppColor.bgColor,
//         appBar: const PreferredSize(
//           preferredSize: Size.fromHeight(60),
//           child: CustomAppBar(
//             title: "Payment",
//             isBack: true,
//           ),
//         ),
//         body: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(color: Colors.white),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text: "Ironing Service",
//                       size: 18,
//                       fontweights: FontWeight.w400,
//                     ),
//                     Height(8),
//                     Row(
//                       children: [
//                         CustomText(
//                           text: "Starts at: ",
//                           color: Colors.grey,
//                         ),
//                         CustomText(
//                           text: "01:30 pm, 13 May",
//                           fontweights: FontWeight.w400,
//                         ),
//                       ],
//                     ),
//                     Height(8),
//                     Row(
//                       children: [
//                         CustomText(
//                           text: "no of Clothes: ",
//                           color: Colors.grey,
//                         ),
//                         CustomText(
//                           text: "10",
//                           fontweights: FontWeight.w400,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Height(8),
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(color: Colors.white),
//               child: Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
//                   child: ListTile(
//                     dense: true,
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 0.0, vertical: 0.0),
//                     visualDensity:
//                         const VisualDensity(horizontal: 0, vertical: 0),
//                     leading: Image.asset(
//                       AppAssets.offerIcon,
//                       height: 30,
//                     ),
//                     title: CustomText(
//                       text: "Apply coupons or offers",
//                       size: 14,
//                       fontweights: FontWeight.w500,
//                     ),
//                     trailing: const Icon(Icons.arrow_forward_ios_sharp),
//                   )),
//             ),
//             const Height(8),
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(color: Colors.white),
//               child: Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
//                   child: ListTile(
//                     dense: true,
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 0.0, vertical: 0.0),
//                     visualDensity:
//                         const VisualDensity(horizontal: 0, vertical: 0),
//                     leading: Image.asset(
//                       AppAssets.walletV2,
//                       height: 30,
//                       color: AppColor.appbarColor,
//                     ),
//                     title: CustomText(
//                       text: "Redeem using wallet",
//                       size: 15,
//                       fontweights: FontWeight.w500,
//                     ),
//                     subtitle: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           text: "Credit Balance: ",
//                           color: Colors.grey,
//                         ),
//                         CustomText(
//                           text: "₹100",
//                           color: Colors.grey,
//                         ),
//                       ],
//                     ),
//                     trailing: Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(50),
//                           border:
//                               Border.all(color: AppColor.bgColor, width: 5)),
//                     ),
//                   )),
//             ),
//             const Height(8),
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(color: Colors.white),
//               child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         text: "Payment Details",
//                         size: 16,
//                         fontweights: FontWeight.w500,
//                       ),
//                       const Height(10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           CustomText(
//                             text: "Service Charge ",
//                             color: Colors.grey,
//                           ),
//                           CustomText(
//                             text: "₹150.00",
//                             fontweights: FontWeight.w400,
//                           ),
//                         ],
//                       ),
//                       const Height(10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           CustomText(
//                             text: "Slot Charge ",
//                             color: Colors.grey,
//                           ),
//                           CustomText(
//                             text: "₹10.00",
//                             fontweights: FontWeight.w400,
//                           ),
//                         ],
//                       ),
//                       const Height(10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(20, (index) {
//                           return Container(
//                             width: 8,
//                             height: 1,
//                             margin: const EdgeInsets.symmetric(horizontal: 4),
//                             decoration: const BoxDecoration(
//                               color: Color.fromARGB(255, 196, 196, 196),
//                               // shape: BoxShape.circle,
//                             ),
//                           );
//                         }),
//                       ),
//                       const Height(10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           CustomText(
//                             text: "Total Payable ",
//                             fontweights: FontWeight.w500,
//                           ),
//                           CustomText(
//                             text: "₹110.00",
//                             fontweights: FontWeight.w500,
//                           ),
//                         ],
//                       ),
//                       Height(10),
//                     ],
//                   )),
//             ),
//             const Height(10),
//           ],
//         ),
//         bottomSheet: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color.fromARGB(255, 81, 81, 81).withOpacity(0.1),
//                   blurRadius: 4,
//                   spreadRadius: 2,
//                   offset: const Offset(0, -2), // Upward shadow
//                 ),
//               ],
//             ),
//             child: ContinueButton(
//               // height: 45,
//               text: 'Proceed to Pay ₹123',
//               isValid: true,
//               isLoading: false,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const PaymentScreen()),
//                 );
//               },
//             )));
//   }
// }
