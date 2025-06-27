import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/providers/auth_provider.dart';
import 'package:spinovo_app/providers/profile_provider.dart';
import 'package:spinovo_app/screen/auth/details_screen.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/constants.dart';
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
  final alternatephoneController = TextEditingController();
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
    // Defer profile fetching to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN);
      if (token != null) {
        Provider.of<ProfileProvider>(context, listen: false).fetchUserProfile();
      } else {
        showToast("Please log in to view your profile");
        context.go('/phone');
      }
    });
  }

  void _save() async {
    final name = nameController.text.trim();
    final email = mailController.text.trim();
    final alternateNumber = alternatephoneController.text.trim();

    if (name.isEmpty) {
      showToast('Please enter your full name');
      return;
    }
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showToast('Please enter a valid email id');
      return;
    }
    if (livingType == null || livingType!.isEmpty) {
      showToast('Please select living type');
      return;
    }
    if (alternateNumber.isEmpty) {
      showToast('Please enter your alternate number');
      return;
    }
        if (alternateNumber.length != 10) {
      showToast('Please enter a valid 10-digit alternate mobile number');
      return;
    }

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final success = await profileProvider.updateUserProfile(
        name, email, livingType!, alternateNumber);

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

          final user = profileProvider.userProfile?.data?.profile;

          // Populate controllers only if not initialized and user data is available
          if (!_isInitialized && user != null) {
            nameController.text = user.name ?? '';
            mailController.text = user.email ?? '';
            phoneController.text = user.mobile ?? '';
            alternatephoneController.text = user.alternateNumber ?? '';
            livingType = householdTypes.contains(user.livingType)
                ? user.livingType
                : householdTypes[0];
            _isInitialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Height(4),
                const TextTitle(title: 'Full Name', optionalText: '*'),
                const Height(8),
                customTextField(
                  controller: nameController,
                  hintText: 'Enter full name',
                  keyboardType: TextInputType.text,
                  onChanged: (_) =>
                      setState(() {}), // Update state for button validation
                ),
                const Height(20),
                const TextTitle(title: 'Email id', optionalText: '*'),
                const Height(8),
                customTextField(
                  controller: mailController,
                  hintText: 'Enter email id',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) =>
                      setState(() {}), // Update state for button validation
                ),
                const Height(20),
                const TextTitle(title: 'Alternate Number', optionalText: '*'),
                const Height(8),
                customTextField(
                  controller: alternatephoneController,
                  hintText: 'Enter alternate number',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) =>
                      setState(() {}), // Update state for button validation
                ),
                const Height(20),
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
                    Container(
                      height: 50,
                      width: 60,
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
                    const Widths(10),
                    Expanded(
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
                const Height(40),
                ContinueButton(
                  text: 'Save',
                  isValid: nameController.text.isNotEmpty &&
                      mailController.text.isNotEmpty &&
                      livingType != null,
                  isLoading: profileProvider.isLoading,
                  onTap: _save,
                ),
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
