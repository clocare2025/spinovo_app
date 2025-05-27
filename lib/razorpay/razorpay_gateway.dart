import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:spinovo_app/api/wallet_api.dart';
import 'package:spinovo_app/utiles/constants.dart';

class RazorPayGateway {
  // DialogBoxWidget dialogBoxWidget = DialogBoxWidget();
  Razorpay razorpay = Razorpay();
  WalletApi walletApi = WalletApi();

  void initiateRazorpay(
      int amounts, int number, String email, BuildContext context) {
    Future<void> razorPayGateway() async {
      try {
        int amount = amounts;
        int mobileNumber = number;
        String emailId = email;

        var options = {
          'key': AppConstants.RAZORPAY_KEY_ID,
          'amount': amount * 100,
          'name': '  CLOCARE',
          'description': '',
          'retry': {'enabled': true, 'max_count': 1},
          'send_sms_hash': true,
          'prefill': {'contact': mobileNumber, 'email': emailId},
          'theme': {'color': '#004aad'},
          "method": "debit",
        };

        razorpay.open(options);
      } catch (e) {
        // print("Error in Razorpay: $e");
      }
    }

    void handlePaymentErrorResponse(PaymentFailureResponse response) {
      void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
        String message = 'pay';
        String status = 'SUCCESS';
        String transactionId = response.paymentId.toString();
        String amountCreditReason = 'SUCCESS';
        String paymentGetewayResporse = 'SUCCESS';
        int amount = amounts;
      }

      void handleExternalWalletSelected(ExternalWalletResponse response) {}

      razorPayGateway();
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    }
  }
}
