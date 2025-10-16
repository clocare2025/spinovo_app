import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/models/order_place_model.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/providers/order_place_provider.dart';
import 'package:spinovo_app/providers/wallet_provider.dart';
import 'package:spinovo_app/razorpay/payment_utils.dart';
import 'package:spinovo_app/screen/address/address_screen.dart';
import 'package:spinovo_app/screen/coupon/coupon_screen.dart';
import 'package:spinovo_app/services/bottom_navigation.dart';
import 'package:spinovo_app/utiles/assets.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/dot_point_widget.dart';
import 'package:spinovo_app/widget/retry_widget.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedTip = 0;
  int handlingCharge = 6;
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
        ChangeNotifierProvider.value(
            value: Provider.of<OrderPlaceDetailsProvider>(context)),
      ],
      child:
          Consumer3<WalletProvider, AddressProvider, OrderPlaceDetailsProvider>(
        builder: (context, walletProvider, addressProvider,
            orderPlaceDetailsProvider, child) {
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
          OrderPlaceDetailsModel orderDetails =
              orderPlaceDetailsProvider.booking;
          final charges = {
            'order_amount': orderDetails.orderAmount ?? 0,
            'service_charge': orderDetails.serviceCharges ?? 0,
            'slot_charge': orderDetails.slotCharges ?? 0,
            'tips': _selectedTip,
            'handling_charge': handlingCharge,
            'delivery_charge': orderDetails.deliveryCharge ?? 0,
          };
          final totalPayable = charges.values.reduce((a, b) => a + b);
          final payableAfterWallet = _useWallet
              ? (totalPayable > walletBalance
                  ? totalPayable - walletBalance
                  : 0)
              : totalPayable;

          // widget.bookingDetails['tip_amount'] = _selectedTip;
          // widget.bookingDetails['total_billing'] = totalPayable;

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
                    ? RetryWidget(
                        msg: walletProvider.errorMessage ??
                            addressProvider.errorMessage!,
                        onTap: () {
                          walletProvider.fetchBalance();
                          addressProvider.fetchAddresses();
                        },
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildBookingDetails(defaultAddress, orderDetails),
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
                  // print(widget.bookingDetails['tip_amount']);
                  // print(widget.bookingDetails['total_billing']);
                  // print(widget.bookingDetails);
                  _processPayment(charges, walletBalance, totalPayable,
                      defaultAddress.addressId!, orderDetails);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingDetails(
      AddressData defaultAddress, OrderPlaceDetailsModel orderDetails) {
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
              text: "${orderDetails.serviceName}",
              size: 18,
              fontweights: FontWeight.w400,
            ),
            const Height(8),
            Row(
              children: [
                CustomText(text: "Starts at: ", color: Colors.grey),
                CustomText(
                  text:
                      "${orderDetails.bookingDate} (${orderDetails.bookingTime})",
                  fontweights: FontWeight.w400,
                ),
              ],
            ),
            const Height(8),
            Row(
              children: [
                CustomText(text: "No. of Clothes: ", color: Colors.grey),
                CustomText(
                  text: "${orderDetails.orderQty}",
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
              MaterialPageRoute(builder: (context) => CouponsScreen()),
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
            _buildChargeRow("Order Amount", charges['order_amount']!),
            const Height(10),
            _buildChargeRow("Handling charge", charges['handling_charge']!),
            const Height(10),
            _buildChargeRow("Delivery charge", charges['delivery_charge']!),
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
      Map<String, int> charges,
      int walletBalance,
      int totalPayable,
      String addressId,
      OrderPlaceDetailsModel orderDetails) async {
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

    final Map<String, dynamic> bookingDetails = {
      'order_type': orderDetails.orderType,
      'service_name': orderDetails.serviceName,
      'order_qty': orderDetails.orderQty,
      'delivery_charge': charges['delivery_charge']!,
      'order_amount': charges['order_amount']!,
      'order_details': orderDetails.orderDetails,
      'address_id': addressId,
      'slot_charges': charges['slot_charge']!,
      'booking_date': orderDetails.bookingDate,
      'booking_time': orderDetails.bookingTime,
      'handling_charges': charges['handling_charge']!,
      'service_charges': charges['service_charge']!,
      'tip_amount': charges['tips']!,
      'total_billing': totalPayable,
      'payment_mode': 'Online',
      'payment_status': "Paid",
      'transaction_id': '',
    };

    try {
      await _paymentUtils.processPayment(
        context: context,
        bookingDetails: bookingDetails,
        totalPayable: totalPayable,
        walletBalance: _useWallet ? walletBalance : 0,
        addressId: addressId,
        onSuccess: () {
          _showToast('Payment successful');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavigation()),
          );
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
