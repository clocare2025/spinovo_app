import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/providers/auth_provider.dart';
import 'package:spinovo_app/providers/profile_provider.dart';
import 'package:spinovo_app/screen/auth/details_screen.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/custom_textfield.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final phoneController = TextEditingController();

  String? livingType;
  bool _isInitialized = false;

  final List<String> householdTypes = [
    'Single',
    'Couple',
    'Family',
  ];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.token != null) {
      Provider.of<ProfileProvider>(context, listen: false).fetchUserProfile();
    } else {
      print("Token is null, cannot fetch profile"); // Debug line
      showToast("Please log in to view your profile");
    }
  }

  void _save() async {
    final name = nameController.text.trim();
    final email = mailController.text.trim();

    if (name.isEmpty) {
      showToast('Please enter your full name');
      return;
    }
    if (email.isEmpty) {
      showToast('Please enter your email id');
      return;
    }
    if (livingType == null || livingType!.isEmpty) {
      showToast('Please select living type');
      return;
    }

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final success = await profileProvider.updateUserProfile(name, email, livingType!);

    if (success) {
      showToast('Profile updated successfully');
      setState(() {
        _isInitialized = false; // Reset to allow re-population
      });
    } else {
      showToast(profileProvider.errorMessage ?? 'Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColors,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Profile",
          isBack: true,
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (profileProvider.errorMessage != null) {
            return Center(child: Text(profileProvider.errorMessage!));
          }

          final user = profileProvider.userProfile?.data?.user;

          // Debug user data
          print("User data: ${user?.toJson()}");

          // Populate controllers only if not initialized and user data is available
          if (!_isInitialized && user != null) {
            nameController.text = user.name ?? '';
            mailController.text = user.email ?? '';
            phoneController.text = user.mobile ?? '';
            // Set livingType only if it's valid
            livingType = householdTypes.contains(user.livingType) ? user.livingType : householdTypes[0];
            _isInitialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Height(20),
                const TextTitle(title: 'Full Name', optionalText: '*'),
                const Height(8),
                customTextField(
                  controller: nameController,
                  hintText: 'Enter full name',
                  keyboardType: TextInputType.text,
                ),
                const Height(20),
                const TextTitle(title: 'Email id', optionalText: ''),
                const Height(8),
                customTextField(
                  controller: mailController,
                  hintText: 'Enter email id',
                  keyboardType: TextInputType.emailAddress,
                ),
                const Height(25),
                const TextTitle(title: 'Select Living Type', optionalText: '*'),
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
                          onTap: () {
                            setState(() => livingType = type);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const Height(20),
                const TextTitle(title: 'Phone Number', optionalText: '*'),
                const Height(8),
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
                        controller: phoneController,
                        hintText: 'Enter mobile number',
                        keyboardType: TextInputType.number,
                        enabled: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),
                  ],
                ),
                const Height(200),
                ContinueButton(
                  text: 'Save',
                  isValid: true,
                  isLoading: profileProvider.isLoading,
                  onTap: _save,
                ),
                const Height(20),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}