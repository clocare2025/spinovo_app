import 'package:flutter/material.dart';
import 'package:spinovo_app/models/otp_model.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/custom_textfield.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class DetailsScreen extends StatefulWidget {
  final OtpResponse otpResponse;
  const DetailsScreen({super.key, required this.otpResponse});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController familyMamber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColors,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.appbarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextTitle(
              title: 'Your Full Name ',
            ),
            const Height(6),
            customTextField(
              controller: userName,
              hintText: 'Enter full name',
              keyboardType: TextInputType.name,
            ),
            const Height(20),
            const TextTitle(
              title: 'Family Mamber ',
              optionalText: '(Optional)',
            ),
            const Height(6),
            customTextField(
              controller: familyMamber,
              hintText: 'Enter number of family members',
              keyboardType: TextInputType.number,
            ),
            const Height(20),
            const TextTitle(
              title: 'Household type ',
              optionalText: '(Optional)',
            ),
            const Height(6),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFD8DADC),
                  width: 1,
                ),
              ),
              child: Center(
                child: CustomText(
                  text: 'Single',
                  color: AppColor.textColor,
                  size: 16,
                ),
              ),
            ),
            const Height(20),
            const Height(50),
            ContinueButton(
              text: 'Continue',
              isValid: true,
              isLoading: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class TextTitle extends StatelessWidget {
  final String title;
  final String? optionalText;
  const TextTitle({
    super.key,
    required this.title,
    this.optionalText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          text: title,
          size: 15,
          fontweights: FontWeight.w500,
        ),
        CustomText(
          text: optionalText ?? '',
          size: 13,
          color: Colors.grey,
        ),
      ],
    );
  }
}
