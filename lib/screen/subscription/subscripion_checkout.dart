import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/providers/package_subscription.dart';
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

class SubscriptionCheckoutScreen extends StatefulWidget {
  final Map<String, Object> buyPackage; // from PackageScreen

  const SubscriptionCheckoutScreen({super.key, required this.buyPackage});

  @override
  State<SubscriptionCheckoutScreen> createState() =>
      _SubscriptionCheckoutScreenState();
}

class _SubscriptionCheckoutScreenState
    extends State<SubscriptionCheckoutScreen> {
  // ---------- UI state ----------
  int _selectedTip = 0;
  final int _handlingCharge = 0;
  bool _useWallet = false;
  bool _isNavigating = false;
  bool _isProcessing = false;
  DateTime? _lastToastTime;

  // ---------- Helpers ----------
  late final PaymentUtils _paymentUtils;
  final DateFormat _dateFmt = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFmt = DateFormat('hh:mm a');

  late final String _startDate;
  late final String _startTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = _dateFmt.format(now);
    _startTime = _timeFmt.format(now);

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

  void _showToast(String msg) {
    final now = DateTime.now();
    if (_lastToastTime == null ||
        now.difference(_lastToastTime!).inMilliseconds > 2000) {
      showToast(msg);
      _lastToastTime = now;
    }
  }

  // ---------- API CALL ----------
// ---------- FIXED: API CALL ----------
Future<void> _buySubscription({
  required String addressId,
  required int walletBalance,
  required int totalPayable,
}) async {
  if (_isProcessing) return;
  setState(() => _isProcessing = true);

  final payload = {
    "address_id": addressId,
    "subscription_id": widget.buyPackage['id'],
    "name": widget.buyPackage['name'],
    "validity": widget.buyPackage['validity'],
    "clothes": widget.buyPackage['clothes'],
    "discount_rate": widget.buyPackage['discount_rate'],
    "prices": widget.buyPackage['prices'],
    "no_of_pickups": widget.buyPackage['no_of_pickups'],
    "total_billing": totalPayable,
    "payment_mode": "Online",
    "transaction_id": "", // will be filled by Razorpay
    "start_date": _startDate,
    "start_time": _startTime,
  };

  try {
    await _paymentUtils.processPayment(
      context: context,
      bookingDetails: payload,
      totalPayable: totalPayable,
      walletBalance: _useWallet ? walletBalance : 0,
      addressId: addressId,
      onSuccess: () async {
        // --- CRITICAL: Use a fresh context from BuildContext ---
        if (!mounted) return;

        // Generate transaction ID
        final transactionId = "razorpay_${DateTime.now().millisecondsSinceEpoch}";
        payload["transaction_id"] = transactionId;

        try {
          // Call Buy API
          await Provider.of<PackageSubscripionProvider>(context, listen: false)
              .buyPackage(payload);

          if (!mounted) return;

          _showToast('Subscription purchased successfully!');

          // --- FIXED NAVIGATION ---
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const BottomNavigation(indexSet: 0)),
            (route) => false,
          );
        } catch (e) {
          if (!mounted) return;
          _showToast('Payment successful, but subscription failed: $e');
        }
      },
      onError: (err) {
        if (!mounted) return;
        _showToast('Payment failed: $err');
      },
    );
  } catch (e) {
    if (!mounted) return;
    _showToast('Unexpected error: $e');
  } finally {
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }
}

  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Provider.of<WalletProvider>(context),
        ),
        ChangeNotifierProvider.value(
          value: Provider.of<AddressProvider>(context),
        ),
      ],
      child: Consumer2<WalletProvider, AddressProvider>(
        builder: (context, wallet, address, _) {
          final walletBal =
              wallet.walletBalance?.data?.wallet?.totalBalance?.toInt() ?? 0;

          final defaultAddr = address.addresses.firstWhere(
            (a) => a.isPrimary == true,
            orElse: () => address.addresses.isNotEmpty
                ? address.addresses.first
                : AddressData(addressId: null, formatAddress: 'No address'),
          );

          // ---------- Billing ----------
          final int basePrice = widget.buyPackage['prices'] as int;
          final int total = basePrice + _handlingCharge + _selectedTip;
          final int payableAfterWallet = _useWallet
              ? (total > walletBal ? total - walletBal : 0)
              : total;

          return Scaffold(
            backgroundColor: AppColor.bgColor,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: CustomAppBar(title: "Checkout", isBack: true),
            ),
            body: wallet.isLoading || address.isLoading
                ? const Center(child: CircularProgressIndicator())
                : wallet.errorMessage != null || address.errorMessage != null
                ? RetryWidget(
                    msg: wallet.errorMessage ?? address.errorMessage!,
                    onTap: () {
                      wallet.fetchBalance();
                      address.fetchAddresses();
                    },
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildPackageInfo(defaultAddr),
                        const Height(8),
                        _buildCouponsSection(),
                        const Height(8),
                        _buildWalletSection(walletBal),
                        const Height(8),
                        _buildTipsSection(),
                        const Height(8),
                        _buildBillingSection(basePrice, total),
                        const Height(200),
                      ],
                    ),
                  ),
            bottomSheet: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A515151),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ContinueButton(
                text: payableAfterWallet > 0
                    ? 'Pay ₹$payableAfterWallet'
                    : 'Confirm Booking',
                isValid: defaultAddr.addressId != null && !_isProcessing,
                isLoading:
                    wallet.isLoading || address.isLoading || _isProcessing,
                onTap: () {
                  if (_isNavigating || _isProcessing) return;
                  if (defaultAddr.addressId == null) {
                    _showToast('Select an address first');
                    _isNavigating = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddressScreen(
                          selectedAddressId: defaultAddr.addressId,
                        ),
                      ),
                    ).then((_) => _isNavigating = false);
                    return;
                  }
                  _buySubscription(
                    addressId: defaultAddr.addressId!,
                    walletBalance: walletBal,
                    totalPayable: payableAfterWallet,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------------------
  Widget _buildPackageInfo(AddressData defaultAddr) {
    final p = widget.buyPackage;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "${p['name']}",
            size: 18,
            fontweights: FontWeight.w400,
          ),
          const Height(8),
          _row("Starts at:", "$_startDate ($_startTime)"),
          const Height(8),
          _row("Validity:", "${p['validity']} days"),
          const Height(8),
          _row("Clothes:", "${p['clothes']}"),
          const Height(8),
          _row("Pickups:", "${p['no_of_pickups']}"),
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
                        builder: (_) => AddressScreen(
                          selectedAddressId: defaultAddr.addressId,
                        ),
                      ),
                    ).then((_) => _isNavigating = false);
                  },
                  child: CustomText(
                    text: defaultAddr.formatAddress ?? 'Select address',
                    color: defaultAddr.addressId == null
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Row(
    children: [
      CustomText(text: label, color: Colors.grey),
      CustomText(text: value, fontweights: FontWeight.w400),
    ],
  );

  // -------------------------------------------------------------------------
  Widget _buildCouponsSection() => Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: ListTile(
      dense: true,
      leading: Image.asset(AppAssets.offerIcon, height: 30),
      title: CustomText(
        text: "Apply coupons or offers",
        size: 14,
        fontweights: FontWeight.w500,
      ),
      trailing: const Icon(Icons.arrow_forward_ios_sharp),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CouponsScreen()),
      ),
    ),
  );

  // -------------------------------------------------------------------------
  Widget _buildWalletSection(int balance) => Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: ListTile(
      dense: true,
      leading: Image.asset(
        AppAssets.walletV2,
        height: 30,
        color: AppColor.appbarColor,
      ),
      title: CustomText(
        text: "Redeem using wallet",
        size: 15,
        fontweights: FontWeight.w500,
      ),
      subtitle: Row(
        children: [
          CustomText(text: "Credit Balance: ", color: Colors.grey),
          CustomText(text: "₹$balance", color: Colors.grey),
        ],
      ),
      trailing: Checkbox(
        value: _useWallet,
        onChanged: balance > 0
            ? (v) => setState(() => _useWallet = v ?? false)
            : null,
      ),
    ),
  );

  // -------------------------------------------------------------------------
  Widget _buildTipsSection() {
    final tips = [10, 20, 30, 50];
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Tip your co-pilot partner",
                size: 16,
                fontweights: FontWeight.w500,
              ),
              Lottie.asset('asset/icons/delivery_copilot.json', height: 30),
            ],
          ),
          const Height(3),
          CustomText(
            text:
                "Your tip goes 100% to the partner who provided quick laundry and ironing service at your doorstep.",
            size: 10,
            overFlow: TextOverflow.visible,
          ),
          const Height(10),
          Row(
            children: tips.map((t) {
              final sel = _selectedTip == t;
              return GestureDetector(
                onTap: () => setState(() => _selectedTip = sel ? 0 : t),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFFE9FFEB) : Colors.white,
                    border: Border.all(
                      color: sel ? const Color(0xFF33C362) : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text: "₹$t",
                    fontweights: sel ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  Widget _buildBillingSection(int base, int total) => Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Billing Details",
          size: 16,
          fontweights: FontWeight.w500,
        ),
        const Height(10),
        _chargeRow("Package Price", base),
        const Height(10),
        _chargeRow("Platform charge", _handlingCharge),
        if (_selectedTip > 0) ...[
          const Height(10),
          _chargeRow("Tip", _selectedTip),
        ],
        const Height(10),
        const dotPointWidget(),
        const Height(10),
        _chargeRow("Total Payable", total, isTotal: true),
      ],
    ),
  );

  Widget _chargeRow(
    String title,
    int amount, {
    bool isTotal = false,
    Color? color,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        text: title,
        fontweights: isTotal ? FontWeight.w500 : FontWeight.normal,
        color: color ?? (isTotal ? Colors.black : Colors.grey),
      ),
      CustomText(
        text: "₹$amount",
        fontweights: isTotal ? FontWeight.w500 : FontWeight.w400,
        color: color ?? Colors.black,
      ),
    ],
  );
}
