import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:spinovo_app/api/order_api.dart';
import 'package:spinovo_app/api/wallet_api.dart';
import 'package:spinovo_app/models/order_model.dart';
import 'package:spinovo_app/providers/order_provider.dart';
import 'package:spinovo_app/providers/wallet_provider.dart';
import 'package:spinovo_app/utiles/constants.dart';
import 'package:spinovo_app/utiles/toast.dart';

class PaymentUtils {
  final Razorpay _razorpay = Razorpay();
  final WalletApi _walletApi = WalletApi();
  final OrderApi _orderApi = OrderApi();

  PaymentUtils() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  Future<void> processPayment({
    required BuildContext context,
    required Map<String, dynamic> bookingDetails,
    required int totalPayable,
    required int walletBalance,
    required int tipsAmount,
    required String addressId,
    required VoidCallback onSuccess,
    required Null Function(dynamic error) onError,
  }) async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    try {
      // Handle tips if any
      // if (tipsAmount > 0) {
      //   await walletProvider.credit(
      //     amount: tipsAmount,
      //     transactionId: 'TIP_${DateTime.now().millisecondsSinceEpoch}',
      //     gatewayResponse: 'success',
      //     reason: 'tip for service',
      //     message: 'Tip of ₹$tipsAmount added',
      //   );
      //   showToast('Tip of ₹$tipsAmount added to wallet');
      // }

      // Calculate payment split
      int remainingAmount = totalPayable;
      bool useWallet = walletBalance > 0 && remainingAmount > 0;

      if (useWallet) {
        int walletDeduction =
            walletBalance >= remainingAmount ? remainingAmount : walletBalance;
        if (walletDeduction > 0) {
          await walletProvider.debit(
            amount: walletDeduction.toInt(),
            transactionId: 'BOOKING_${DateTime.now().millisecondsSinceEpoch}',
            gatewayResponse: 'success',
            reason: 'booking ${bookingDetails['order_display_no'] ?? 'ORD'}',
            message: 'Payment of ₹$walletDeduction for booking',
          );
          remainingAmount -= walletDeduction;
          showToast('₹$walletDeduction deducted from wallet');
        }
      }

      // Update booking details with transaction ID
      bookingDetails['transaction_id'] =
          'TXN_${DateTime.now().millisecondsSinceEpoch}';

      if (remainingAmount > 0) {
        // Initiate Razorpay payment for remaining amount
        var options = {
          'key': AppConstants.RAZORPAY_KEY_ID,
          'amount': (remainingAmount * 100).toInt(), // Convert to paise
          'name': 'CLOCARE',
          'description':
              'Booking Payment for ${bookingDetails['order_display_no'] ?? 'Order'}',
          'retry': {'enabled': true, 'max_count': 1},
          'send_sms_hash': true,
          'prefill': {
            'contact': '1234567890', // Replace with actual user data
            'email': 'user@example.com', // Replace with actual user data
          },
          'theme': {'color': '#004aad'},
          'external': {
            'wallets': ['paytm', 'phonepe', 'gpay']
          }
        };

        _razorpay.open(options);
        // Store context and success callback for async handling
        _paymentSuccessCallback = () async {
          onSuccess();
          // Create booking
          OrderModel orderResponse = await _orderApi.booking(bookingDetails);
          orderProvider.fetchOrders(); // Refresh order list
          showToast(
              'Booking successful: ${orderResponse.data?.order?.orderDisplayNo}');
        };
      } else {
        // No Razorpay needed, booking complete
        onSuccess();
        // Create booking
        OrderModel orderResponse = await _orderApi.booking(bookingDetails);
        orderProvider.fetchOrders(); // Refresh order list
        showToast(
            'Booking successful: ${orderResponse.data?.order?.orderDisplayNo}');
      }
    } catch (e) {
      showToast('Payment failed: $e');
    }
  }

  VoidCallback? _paymentSuccessCallback;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_paymentSuccessCallback != null) {
      _paymentSuccessCallback!();
      _paymentSuccessCallback = null;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showToast('Payment failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showToast('External wallet selected: ${response.walletName}');
  }
}
