import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/otp_model.dart';
import 'package:spinovo_app/providers/auth_provider.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/otp_box.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class OtpScreen extends StatefulWidget {
  final OtpResponse otpResponse;
  const OtpScreen({super.key, required this.otpResponse});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController num1 = TextEditingController();
  final TextEditingController num2 = TextEditingController();
  final TextEditingController num3 = TextEditingController();
  final TextEditingController num4 = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    num1.dispose();
    num2.dispose();
    num3.dispose();
    num4.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining == 0) {
          timer.cancel();
          _canResend = true;
        } else {
          _secondsRemaining--;
        }
      });
    });
  }

  void _resendOtp() async {
    if (!_canResend) {
      showToast('Please wait for 60 seconds before resending OTP');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await authProvider.sendOtp(widget.otpResponse.mobileNo!);
      if (response != null && response.status == true) {
        setState(() {
          _secondsRemaining = 60;
          _canResend = false;
        });
        startTimer();
        showToast('OTP resent successfully');
      } else {
        showToast(authProvider.errorMessage ?? 'Failed to resend OTP');
      }
    } catch (e) {
      showToast('Error: $e');
    }
  }

  void _confirmOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final enteredOtp = num1.text + num2.text + num3.text + num4.text;

    if (enteredOtp.length != 4) {
      showToast('Please enter a valid 4-digit OTP');
      return;
    }

    if (enteredOtp == widget.otpResponse.otpCode) {
      if (widget.otpResponse.otpRequest == 'login') {
        final response = await authProvider.login(widget.otpResponse.mobileNo!);
        print('login response ${response}');
        print('login response ${response!.status}');
        if (response!.status == true) {
          context.go('/home');
          showToast('Login successful');
        } else {
          showToast(authProvider.errorMessage ?? 'Login failed');
        }
      } else if (widget.otpResponse.otpRequest == 'signup') {
        context.go('/details', extra: widget.otpResponse);
        showToast('OTP verified successfully');
      } else {
        showToast('Invalid OTP request type');
      }
    } else {
      showToast('Invalid OTP code');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.backgroundColors,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/phone'),
        ),
        iconTheme: IconThemeData(color: AppColor.textColor),
        backgroundColor: AppColor.backgroundColors,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SmallText(
                      text: 'Verification code',
                      size: 23,
                      fontweights: FontWeight.w500,
                      color: AppColor.textColor,
                    ),
                    const Height(5),
                    SmallText(
                      text: 'Please enter the OTP sent to your',
                      size: 13,
                      fontweights: FontWeight.w400,
                      color: Colors.grey,
                      overFlow: TextOverflow.visible,
                    ),
                    SmallText(
                      text: 'phone number +91 ${widget.otpResponse.mobileNo}',
                      size: 13,
                      fontweights: FontWeight.w400,
                      color: Colors.grey,
                      overFlow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
              const Height(25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OtpBox(
                    controller: num1,
                    onChanged: (value) {
                      if (value.length == 1) focusNode2.requestFocus();
                    },
                    focusNode: focusNode1,
                    nextFocusNode: focusNode2,
                  ),
                  const Widths(12),
                  OtpBox(
                    controller: num2,
                    onChanged: (value) {
                      if (value.length == 1) {
                        focusNode3.requestFocus();
                      } else if (value.isEmpty) {
                        focusNode1.requestFocus();
                      }
                    },
                    focusNode: focusNode2,
                    nextFocusNode: focusNode3,
                    previousFocusNode: focusNode1,
                  ),
                  const Widths(12),
                  OtpBox(
                    controller: num3,
                    onChanged: (value) {
                      if (value.length == 1) {
                        focusNode4.requestFocus();
                      } else if (value.isEmpty) {
                        focusNode2.requestFocus();
                      }
                    },
                    focusNode: focusNode3,
                    nextFocusNode: focusNode4,
                    previousFocusNode: focusNode2,
                  ),
                  const Widths(12),
                  OtpBox(
                    controller: num4,
                    onChanged: (value) {
                      if (value.isEmpty) focusNode3.requestFocus();
                    },
                    focusNode: focusNode4,
                    previousFocusNode: focusNode3,
                  ),
                ],
              ),
              const Height(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SmallText(
                    text: 'Resend code after ',
                    color: const Color(0xFF5a5a60),
                    size: 14,
                  ),
                  SmallText(
                    text: '$_secondsRemaining sec',
                    size: 14,
                    color: _secondsRemaining < 20
                        ? Colors.red
                        : AppColor.textColor,
                  ),
                ],
              ),
              const Height(25),
              InkWell(
                onTap: _resendOtp,
                child: SmallText(
                  text: 'Resend code',
                  color:
                      _canResend ? AppColor.textColor : const Color(0xFF5a5a60),
                ),
              ),
              const Height(40),
              ContinueButton(
                text: 'Confirm',
                isValid: true,
                isLoading: authProvider.isLoading,
                onTap: _confirmOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
