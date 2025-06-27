import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/providers/wallet_provider.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/constants.dart';
import 'package:spinovo_app/utiles/designe.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/custom_textfield.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _amountController.text = '100';
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // Fetch initial wallet data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletProvider>(context, listen: false).fetchBalance();
      Provider.of<WalletProvider>(context, listen: false).fetchTransactionHistory();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _startPayment() {
    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    var options = {
      'key': AppConstants.RAZORPAY_KEY_ID,
      'amount': amount * 100, // Convert to paise
      'name': 'CLOCARE',
      'description': 'Wallet Recharge',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '1234567890', // Replace with actual user data
        'email': 'user@example.com', // Replace with actual user data
      },
      'theme': {'color': '#004aad'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initiating payment: $e')),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    try {
      await walletProvider.credit(
        amount: int.parse(_amountController.text),
        transactionId: response.paymentId ?? 'unknown',
        gatewayResponse: 'success',
        reason: 'wallet recharge',
        message: '${_amountController.text} deposit',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful! Wallet credited.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error crediting wallet: $e')),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet selected: ${response.walletName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, child) {
        final walletBalance = walletProvider.walletBalance?.data?.wallet;
        final transactionHistory = walletProvider.transactionHistory?.data?.history ?? [];

        return Scaffold(
          backgroundColor: AppColor.bgColor,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CustomAppBar(
              title: "Wallet",
              isBack: true,
            ),
          ),
          body: walletProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : walletProvider.errorMessage != null
                  ? Center(child: Text(walletProvider.errorMessage!))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  TotalWalletSection(
                                    totalAmount: walletBalance != null
                                        ? '₹${walletBalance.totalBalance}'
                                        : '₹0.0',
                                    cash: walletBalance != null
                                        ? '₹${walletBalance.cash}'
                                        : '₹0.0',
                                    bonus: walletBalance != null
                                        ? '₹${walletBalance.bonus}'
                                        : '₹0.0',
                                  ),
                                  const Height(15),
                                  DepositSection(
                                    amountController: _amountController,
                                    onProceed: _startPayment,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Height(15),
                          Container(
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   CustomText(
                                    text: "Recent Transactions",
                                    size: 15,
                                    fontweights: FontWeight.w500,
                                  ),
                                  const Height(8),
                                  transactionHistory.isEmpty
                                      ?  CustomText(
                                          text: "No transactions available",
                                          size: 14,
                                        )
                                      : Column(
                                          children: transactionHistory
                                              .map((history) => ListTile(
                                                    dense: true,
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 0.0,
                                                            vertical: 0.0),
                                                    visualDensity: const VisualDensity(
                                                        horizontal: 0, vertical: 0),
                                                    title: CustomText(
                                                      text: history.message?.isNotEmpty == true
                                                          ? history.message!
                                                          : history.transactionType == 'credit'
                                                              ? 'Wallet Recharge'
                                                              : 'Wallet Debit',
                                                      size: 14,
                                                    ),
                                                    subtitle: CustomText(
                                                      text: history.createdAt != null
                                                          ? DateTime.parse(history.createdAt!)
                                                              .toLocal()
                                                              .toString()
                                                              .substring(0, 16)
                                                          : 'Unknown date',
                                                      size: 12,
                                                    ),
                                                    leading: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(50),
                                                        color: history.transactionType == 'credit'
                                                            ? Colors.green.withOpacity(0.2)
                                                            : Colors.red.withOpacity(0.2),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          history.transactionType == 'credit'
                                                              ? Icons.add
                                                              : Icons.remove,
                                                          color: history.transactionType == 'credit'
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    trailing: CustomText(
                                                      text: '₹${history.amount}',
                                                      size: 15,
                                                      color: history.transactionType == 'credit'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}

class TotalWalletSection extends StatelessWidget {
  final String totalAmount;
  final String cash;
  final String bonus;
  const TotalWalletSection({
    super.key,
    required this.totalAmount,
    required this.cash,
    required this.bonus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: AppDesigne.boxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             CustomText(
              text: "Total Wallet Balance",
              size: 15,
            ),
            const Height(8),
            HeadingText(
              text: totalAmount,
            ),
            const Height(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AmountWalletBox(
                  title: "Your Cash",
                  amount: cash,
                ),
                const Widths(15),
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCD1CB),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: const Color(0xFFCCD1CB)),
                  ),
                  child: Center(
                    child: CustomText(
                      text: '+',
                      size: 15,
                    ),
                  ),
                ),
                const Widths(15),
                AmountWalletBox(
                  title: "Spinovo Bonus",
                  amount: bonus,
                ),
              ],
            ),
            const Height(8),
            const Divider(color: Color(0xFFCCD1CB)),
            const Height(8),
            const Text(
              'Your wallet balance is fully redeemable for bookings and extensions, and has no expiration date',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class DepositSection extends StatelessWidget {
  final TextEditingController amountController;
  final VoidCallback onProceed;

  const DepositSection({
    super.key,
    required this.amountController,
    required this.onProceed,
  });

  void _setAmount(String amount) {
    amountController.text = amount.replaceAll('₹', '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: AppDesigne.boxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             CustomText(
              text: "Add Money to Wallet",
              size: 15,
              fontweights: FontWeight.w500,
            ),
            const Height(15),
            customTextField(
              controller: amountController,
              hintText: '150',
              prefixText: '₹ ',
              keyboardType: TextInputType.number,
            ),
            const Height(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAmountButton('₹150', context),
                const Widths(8),
                _buildAmountButton('₹500', context),
                const Widths(8),
                _buildAmountButton('₹1000', context),
                const Widths(8),
                _buildAmountButton('₹2000', context),
              ],
            ),
            const Height(35),
            ContinueButton(
              text: 'Proceed',
              isValid: amountController.text.isNotEmpty,
              isLoading: Provider.of<WalletProvider>(context).isLoading,
              onTap: onProceed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(String amount, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _setAmount(amount),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: const Color(0xFFCCD1CB)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: CustomText(
                text: amount,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AmountWalletBox extends StatelessWidget {
  final String title;
  final String amount;
  const AmountWalletBox({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: const Color(0xFFCCD1CB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: title,
              size: 12,
            ),
            CustomText(
              text: amount,
              fontweights: FontWeight.w500,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:spinovo_app/component/custom_appbar.dart';
// import 'package:spinovo_app/utiles/color.dart';
// import 'package:spinovo_app/utiles/constants.dart';
// import 'package:spinovo_app/utiles/designe.dart';
// import 'package:spinovo_app/widget/button.dart';
// import 'package:spinovo_app/widget/custom_textfield.dart';
// import 'package:spinovo_app/widget/size_box.dart';
// import 'package:spinovo_app/widget/text_widget.dart';

// class WalletScreen extends StatefulWidget {
//   const WalletScreen({Key? key}) : super(key: key);

//   @override
//   _WalletScreenState createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   Razorpay razorpay = Razorpay();
//   @override
//   void initState() {
//     super.initState();
//     _amountController.text = '100'; // Default value
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }

//     void paymentCheckout(
//     int amounts,
//     int number,
//     String email,
//   ) {
//     Future<void> razorPayGateway() async {

//       try {
//         int amount = amounts;
//         int mobileNumber = number;
//         String emailId = email;

//         var options = {
//           'key': AppConstants.RAZORPAY_KEY_ID,
//           'amount': amount * 100,
//           'name': '  CLOCARE',
//           'description': '',
//           'retry': {'enabled': true, 'max_count': 1},
//           'send_sms_hash': true,
//           'prefill': {'contact': mobileNumber, 'email': emailId},
//           'theme': {'color': '#004aad'},
//           "method": "debit",
//         };

//         razorpay.open(options);
//       } catch (e) {
//         // print("Error in Razorpay: $e");
//       }
//     }

//     void handlePaymentErrorResponse(PaymentFailureResponse response) {

//     }

//     void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {


//     }

//     void handleExternalWalletSelected(ExternalWalletResponse response) {

//     }

//    razorPayGateway();
//       razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//       razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//       razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.bgColor,
//       appBar: const PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: CustomAppBar(
//           title: "Wallet",
//           isBack: true,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               decoration: const BoxDecoration(color: Colors.white),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   children: [
//                     const TotalWalletSection(
//                       totalAmount: '₹0.0',
//                       cash: '₹0.0',
//                       bonus: '₹0.0',
//                     ),
//                     const Height(15),
//                     DepositSection(),
//                   ],
//                 ),
//               ),
//             ),
//             const Height(15),
//             Container(
//               decoration: const BoxDecoration(color: Colors.white),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text: "Recent Transactions",
//                       size: 15,
//                       fontweights: FontWeight.w500,
//                     ),
//                     const Height(8),
//                     ListTile(
//                       dense: true,
//                       contentPadding:
//                           const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
//                       visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
//                       title: CustomText(
//                         text: "Wallet recharge failed",
//                         size: 14,
//                       ),
//                       subtitle: CustomText(
//                         text: "14 May 2025",
//                         size: 12,
//                       ),
//                       leading: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               color: const Color.fromARGB(128, 175, 76, 76)),
//                           child: const Center(
//                               child: Icon(
//                             Icons.warning,
//                             color: Color.fromARGB(255, 128, 26, 19),
//                           ))),
//                       trailing: CustomText(
//                         text: "₹105.0",
//                         size: 15,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TotalWalletSection extends StatefulWidget {
//   final String totalAmount;
//   final String cash;
//   final String bonus;
//   const TotalWalletSection({
//     super.key,
//     required this.totalAmount,
//     required this.cash,
//     required this.bonus,
//   });

//   @override
//   State<TotalWalletSection> createState() => _TotalWalletSectionState();
// }

// class _TotalWalletSectionState extends State<TotalWalletSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: AppDesigne.boxDecoration,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Wallet Balance Section
//             CustomText(
//               text: "Total Wallet Balance",
//               size: 15,
//             ),
//             const Height(8),

//             HeadingText(
//               text: widget.totalAmount,
//             ),
//             const Height(20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AmountWalletBox(
//                   title: "Your Cash",
//                   amount: widget.cash,
//                 ),
//                 const Widths(15),
//                 Container(
//                   height: 22,
//                   width: 22,
//                   decoration: BoxDecoration(
//                       color: const Color(0xFFCCD1CB),
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(50),
//                       ),
//                       border: Border.all(color: const Color(0xFFCCD1CB))),
//                   child: Center(
//                     child: CustomText(
//                       text: '+',
//                       size: 15,
//                     ),
//                   ),
//                 ),
//                 const Widths(15),
//                 AmountWalletBox(
//                   title: "Spinovo Bonus",
//                   amount: widget.bonus,
//                 ),
//               ],
//             ),
//             const Height(8),
//             const Divider(color: Color(0xFFCCD1CB)),
//             const Height(8),
//             const Text(
//               'Spinovo Cash is fully redeemable for bookings and extensions, and has no expiration date',
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DepositSection extends StatelessWidget {
//   DepositSection({
//     super.key,
//   });
//   final TextEditingController _amountController = TextEditingController();

//   void _setAmount(String amount) {}

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: AppDesigne.boxDecoration,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Add Money to Wallet Section
//             CustomText(
//               text: "Total Wallet Balance",
//               size: 15,
//               fontweights: FontWeight.w500,
//             ),
//             const Height(15),
//             customTextField(
//               controller: _amountController,
//               hintText: '150',
//               prefixText: '₹ ',
//               keyboardType: TextInputType.number,
//             ),

//             const Height(15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildAmountButton('₹150'),
//                 const Widths(8),
//                 _buildAmountButton('₹500'),
//                 const Widths(8),
//                 _buildAmountButton('₹1000'),
//                 const Widths(8),
//                 _buildAmountButton('₹2000'),
//               ],
//             ),
//             const Height(35),
//             ContinueButton(
//               text: 'Proceed',
//               isValid: true,
//               isLoading: false,
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAmountButton(String amount) {
//     return Expanded(
//       child: Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(10),
//               ),
//               border: Border.all(color: const Color(0xFFCCD1CB))),
//           child: Padding(
//             padding: const EdgeInsets.all(8),
//             child: Center(
//               child: CustomText(
//                 text: amount,
//               ),
//             ),
//           )),
//     );
//   }
// }

// class AmountWalletBox extends StatelessWidget {
//   final String title;
//   final String amount;
//   const AmountWalletBox({
//     super.key,
//     required this.title,
//     required this.amount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         height: 50,
//         // width: 100,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.all(Radius.circular(10)),
//             border: Border.all(color: const Color(0xFFCCD1CB))),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CustomText(
//               text: title,
//               size: 12,
//             ),
//             CustomText(
//               text: amount,
//               fontweights: FontWeight.w500,
//               size: 12,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
