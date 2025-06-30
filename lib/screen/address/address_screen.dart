import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/screen/address/address_create_edite_screen.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class AddressScreen extends StatefulWidget {
  final String? selectedAddressId;
  const AddressScreen({super.key, this.selectedAddressId});

  @override
  // ignore: library_private_types_in_public_api
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    });
  }

  void _addNewAddress() {
    // context.go('/address/create');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressCreateEditScreen()),
    );
  }

  void _deleteAddress(String addressId) async {
    try {
      await Provider.of<AddressProvider>(context, listen: false)
          .deleteAddress(addressId);
      showToast('Address deleted successfully');
    } catch (e) {
      showToast('Failed to delete address: $e');
    }
  }

  void _editAddress(String addressId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressCreateEditScreen(addressId: addressId),
      ),
    );
  }

  void _setPrimaryAddress(String addressId) async {
    try {
      await Provider.of<AddressProvider>(context, listen: false)
          .setPrimaryAddress(addressId);
      showToast('Default address set successfully');
      context.pop(); // Return to previous screen
    } catch (e) {
      showToast('Failed to set default address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        return Scaffold(
          backgroundColor: AppColor.bgColor,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CustomAppBar(title: "Addresses", isBack: true),
          ),
          body: addressProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : addressProvider.errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(addressProvider.errorMessage!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => addressProvider.fetchAddresses(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: addressProvider.addresses.isEmpty
                              ? Center(
                                  child: CustomText(
                                    text: "No addresses available",
                                    color: Colors.grey,
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  itemCount: addressProvider.addresses.length,
                                  itemBuilder: (context, index) {
                                    final address =
                                        addressProvider.addresses[index];
                                    final isSelected = address.addressId ==
                                        widget.selectedAddressId;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: isSelected
                                              ? Border.all(
                                                  color: AppColor.appbarColor,
                                                  width: 2)
                                              : null,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.home,
                                                color: Colors.grey, size: 24),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: address.addressType ??
                                                        'Address',
                                                    size: 16,
                                                    fontweights:
                                                        FontWeight.bold,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  CustomText(
                                                    text: address
                                                            .formatAddress ??
                                                        'No address available',
                                                    size: 14,
                                                    color: Colors.black87
                                                        .withOpacity(0.7),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _editAddress(address
                                                                .addressId!),
                                                        child: CustomText(
                                                          text: "Edit",
                                                          size: 15,
                                                          fontweights:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 24),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _deleteAddress(
                                                                address
                                                                    .addressId!),
                                                        child: CustomText(
                                                          text: "Delete",
                                                          size: 15,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 201, 40, 40),
                                                          fontweights:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Radio<bool>(
                                              value: true,
                                              groupValue: address.isPrimary,
                                              onChanged: addressProvider
                                                      .isLoading
                                                  ? null
                                                  : (value) =>
                                                      _setPrimaryAddress(
                                                          address.addressId!),
                                              activeColor: AppColor.appbarColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          child: ContinueButton(
                            text: 'Add new address',
                            isValid: true,
                            isLoading: addressProvider.isLoading,
                            onTap: _addNewAddress,
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
