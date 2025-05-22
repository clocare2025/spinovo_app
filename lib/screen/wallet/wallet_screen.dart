import 'package:flutter/material.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/utiles/color.dart';
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

  @override
  void initState() {
    super.initState();
    _amountController.text = '100'; // Default value
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Wallet",
          isBack: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const TotalWalletSection(
                      totalAmount: '₹0.0',
                      cash: '₹0.0',
                      bonus: '₹0.0',
                    ),
                    const Height(15),
                    DepositSection(),
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
                    ListTile(
                      dense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                      visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                      title: CustomText(
                        text: "Wallet recharge failed",
                        size: 14,
                      ),
                      subtitle: CustomText(
                        text: "14 May 2025",
                        size: 12,
                      ),
                      leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(128, 175, 76, 76)),
                          child: const Center(
                              child: Icon(
                            Icons.warning,
                            color: Color.fromARGB(255, 128, 26, 19),
                          ))),
                      trailing: CustomText(
                        text: "₹105.0",
                        size: 15,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TotalWalletSection extends StatefulWidget {
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
  State<TotalWalletSection> createState() => _TotalWalletSectionState();
}

class _TotalWalletSectionState extends State<TotalWalletSection> {
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
            // Wallet Balance Section
            CustomText(
              text: "Total Wallet Balance",
              size: 15,
            ),
            const Height(8),

            HeadingText(
              text: widget.totalAmount,
            ),
            const Height(20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AmountWalletBox(
                  title: "Your Cash",
                  amount: widget.cash,
                ),
                const Widths(15),
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                      color: const Color(0xFFCCD1CB),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      border: Border.all(color: const Color(0xFFCCD1CB))),
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
                  amount: widget.bonus,
                ),
              ],
            ),
            const Height(8),
            const Divider(color: Color(0xFFCCD1CB)),
            const Height(8),
            const Text(
              'Spinovo Cash is fully redeemable for bookings and extensions, and has no expiration date',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class DepositSection extends StatelessWidget {
  DepositSection({
    super.key,
  });
  final TextEditingController _amountController = TextEditingController();

  void _setAmount(String amount) {}

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
            // Add Money to Wallet Section
            CustomText(
              text: "Total Wallet Balance",
              size: 15,
              fontweights: FontWeight.w500,
            ),
            const Height(15),
            customTextField(
              controller: _amountController,
              hintText: '150',
              prefixText: '₹ ',
              keyboardType: TextInputType.number,
            ),

            const Height(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAmountButton('₹150'),
                const Widths(8),
                _buildAmountButton('₹500'),
                const Widths(8),
                _buildAmountButton('₹1000'),
                const Widths(8),
                _buildAmountButton('₹2000'),
              ],
            ),
            const Height(35),
            ContinueButton(
              text: 'Proceed to pay',
              isValid: true,
              isLoading: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(String amount) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(color: const Color(0xFFCCD1CB))),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: CustomText(
                text: amount,
              ),
            ),
          )),
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
        // width: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: const Color(0xFFCCD1CB))),
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
