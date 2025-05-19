import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spinovo_app/api/auth_api.dart';
import 'package:spinovo_app/screen/auth/otp_screen.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/custom_textfield.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _mobileNumberController = TextEditingController();
  AuthApi authApi = AuthApi();
  bool isLoading = false;

  @override
  void dispose() {
    _mobileNumberController.dispose();

    super.dispose();
  }

  void continueBtn() async {
    String userNumber = _mobileNumberController.text.trim();
    if (userNumber.isEmpty) {
      showToast('Please enter your mobile number');
    } else if (userNumber.length < 10) {
      showToast('Please enter a valid mobile number');
    } else {
    

      setState(() {
        isLoading = true;
      });
      await authApi.sendOtp(userNumber).then((response) {
        setState(() {
          isLoading = false;
        });
        if (response.status == true) {
          var responseData = response.data!.otpResponse!;
     

          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  OtpScreen(otpResponse: responseData,)));
        } else {
          showToast('Failed to send OTP');
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        showToast('Error: $error');
      });
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColors,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Height(80),
                Center(
                  child: HeadingText(
                    text: "Spinovo",
                    size: 35,
                    color: AppColor.appbarColor,
                  ),
                ),
                const Height(20),
                CustomText(text: 'Enter your mobile number to continue',),
                const Height(10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                            text: '+91',
                            color: AppColor.textColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    const Widths(10),
                    Expanded(
                      flex: 4,
                      child: customTextField(
                        controller: _mobileNumberController,
                        hintText: 'Enter mobile number',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),
                  ],
                ),
                const Height(15),
                CustomText(text: 'We will send an OTP to verify your number'),
                const Height(50),
                ContinueButton(
                  text: 'Continue',
                  isValid: true,
                  isLoading: isLoading,
                  onTap: () {
                    continueBtn();
                  },
                ),
              ],
            ),
            Column(
              children: [
                CustomText(
                  text: "By clicking, I accept the ",
                  letterSpacing: -0.26,
                  color: const Color(0xFF525871),
                ),
                const Height(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Terms of Use",
                      letterSpacing: -0.26,
                      decoration: TextDecoration.underline,
                      color: const Color(0xFF525871),
                    ),
                    CustomText(
                      text: "  &  ",
                      letterSpacing: -0.26,
                      color: const Color(0xFF525871),
                    ),
                    CustomText(
                      text: "Privacy Policy",
                      letterSpacing: -0.26,
                      decoration: TextDecoration.underline,
                      color: const Color(0xFF525871),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
