import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/api/auth_api.dart';
import 'package:spinovo_app/models/otp_model.dart';
import 'package:spinovo_app/screen/address/address_create_screen.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/constants.dart';
import 'package:spinovo_app/utiles/toast.dart';
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
  AuthApi authApi = AuthApi();
  final TextEditingController userName = TextEditingController();
  String? livingType;
  bool isLoading = false;

  final List<String> householdTypes = [
    'Single',
    'Couple',
    'Family',
  ];

  void continueBtn() {
    String name = userName.text.trim();
    String mobileNo = widget.otpResponse.mobileNo.toString();

    if (name.isEmpty) {
      showToast('Please enter your full name');
    } else if (livingType == null || livingType!.isEmpty) {
      showToast('Please select living Type ');
    } else {
      setState(() {
        isLoading = true;
      });

      authApi.userSignup(name, mobileNo, livingType!).then((response) async {
        setState(() {
          isLoading = false;
        });
        if (response.status == true) {
          var responseData = response.data!;
          String token = responseData.user!.accessToken.toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(AppConstants.TOKEN, token);
          showToast(response.msg!);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddressMapScreen(),
            ),
          );
        } else {
          showToast('Failed to signup');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextTitle(
                title: 'Your Full Name ',
              ),
              const Height(8),
              customTextField(
                controller: userName,
                hintText: 'Enter full name',
                keyboardType: TextInputType.name,
              ),
              const Height(25),
              const TextTitle(
                title: 'Select Living Type ',
                optionalText: '',
              ),
              const Height(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: householdTypes.map((type) {
                  final isSelected = livingType == type;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: HouseholdTypeBox(
                        text: type,
                        isSelected: isSelected,
                        onTap: () => setState(() => livingType = type),
                      ),
                    ),
                  );
                }).toList(),
              ),
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
        ),
      ),
    );
  }
}

class HouseholdTypeBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const HouseholdTypeBox({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(227, 76, 175, 79)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.green.shade500 : const Color(0xFFD8DADC),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: text,
          color: isSelected ? Colors.white : AppColor.textColor,
          size: 13,
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
