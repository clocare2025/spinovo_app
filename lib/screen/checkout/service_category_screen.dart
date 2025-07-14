import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/providers/order_place_provider.dart';
import 'package:spinovo_app/providers/services_provider.dart';
import 'package:spinovo_app/screen/address/address_screen.dart';
import 'package:spinovo_app/screen/checkout/checkout_screen_v3.dart';
import 'package:spinovo_app/screen/checkout/widgets/checkout_appbar.dart';
import 'package:spinovo_app/screen/checkout/widgets/garment_box_widget.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/service_category_widget.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class ServiceCategoryScreen extends StatefulWidget {
  final int serviceId;
  const ServiceCategoryScreen({super.key, required this.serviceId});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceCategoryScreenState createState() => _ServiceCategoryScreenState();
}

class _ServiceCategoryScreenState extends State<ServiceCategoryScreen> {
  int? _selectedServiceId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final servicesProvider =
          Provider.of<ServicesProvider>(context, listen: false);
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);

      // Fetch services
      await servicesProvider.getServices();
      if (mounted) {
        setState(() {
          final services = servicesProvider.servicesList?.data?.service;
          if (services != null && services.isNotEmpty) {
            _selectedServiceId = services
                .firstWhere(
                  (s) => s.serviceId == widget.serviceId,
                  orElse: () => services.first,
                )
                .serviceId;
          }
        });
      }
      // Fetch addresses
      addressProvider.fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServicesProvider, AddressProvider>(
      builder: (context, servicesProvider, addressProvider, child) {
        final defaultAddress = addressProvider.addresses.firstWhere(
          (address) => address.isPrimary == true,
          orElse: () => addressProvider.addresses.isNotEmpty
              ? addressProvider.addresses.first
              : AddressData(addressId: null),
        );

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBarCheckout(addressId: defaultAddress.addressId),
          ),
          body: servicesProvider.isLoading || addressProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : servicesProvider.errorMessage != null ||
                      addressProvider.errorMessage != null
                  ? _retryWidget(servicesProvider, addressProvider)
                  : _buildBody(servicesProvider),
          bottomSheet: _buildBottomSheet(servicesProvider),
        );
      },
    );
  }

  Widget _buildBody(ServicesProvider servicesProvider) {
    final servicesList = servicesProvider.servicesList?.data?.service ?? [];
    if (servicesList.isEmpty) {
      return Center(
        child: CustomText(
          text: "No services available",
          color: Colors.grey,
        ),
      );
    }

    final selectedService = _selectedServiceId != null
        ? servicesList.firstWhere(
            (service) => service.serviceId == _selectedServiceId,
            orElse: () => servicesList.first,
          )
        : servicesList.first;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Choose service",
              size: 16,
              fontweights: FontWeight.w500,
            ),
            const Height(15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: servicesList.asMap().entries.map((entry) {
                  final service = entry.value;
                  final serviceEntry =
                      servicesProvider.selectedServiceCategories.firstWhere(
                    (entry) => entry['service_id'] == service.serviceId,
                    orElse: () => {'categorys': []},
                  );
                  final int itemCount = (serviceEntry['categorys'] as List)
                      .fold<int>(
                          0,
                          (sum, cat) =>
                              sum + (int.parse(cat['items'].toString()) ?? 0));
                  return CategoryServiceBox(
                    title: service.service!,
                    onTap: () {
                      setState(() {
                        _selectedServiceId = service.serviceId;
                      });
                    },
                    bgColor: _selectedServiceId == service.serviceId
                        ? const Color(0xFFE9FFEB)
                        : Colors.white,
                    borderColor: _selectedServiceId == service.serviceId
                        ? const Color(0xFF33C362)
                        : Colors.grey[300]!,
                    onOfClothe: itemCount,
                  );
                }).toList(),
              ),
            ),
            const Height(20),
            CustomText(
              text: "Service Details",
              size: 16,
              fontweights: FontWeight.w500,
            ),
            const Height(10),
            ServicDetailseBox(
              title: selectedService.description ?? '',
              duration: "Service duration: ${selectedService.duration}",
            ),
            const Height(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  text: "Categories",
                  size: 14,
                  fontweights: FontWeight.w500,
                ),
                if (servicesProvider.selectedServiceCategories.isNotEmpty)
                  InkWell(
                    onTap: () {
                      servicesProvider.clearServiceCategory();
                    },
                    child: SmallText(
                      text: "Remove all ",
                      size: 12,
                      color: const Color.fromARGB(255, 210, 58, 47),
                      fontweights: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            const Height(10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedService.categoryList?.length ?? 0,
              itemBuilder: (context, index) {
                final category = selectedService.categoryList![index];
                final qty = servicesProvider.getItemsForCategory(
                    selectedService.serviceId!, category.categoryId!);
                return GarmentBoxWidget(
                  name: category.category!,
                  price: '₹${category.price}',
                  qty: qty,
                  quantity: qty.toString(),
                  add: () {
                    servicesProvider.addServiceCategory(
                      serviceId: selectedService.serviceId!,
                      service: selectedService.service!,
                      duration: selectedService.duration!,
                      description: selectedService.description!,
                      categoryId: category.categoryId!,
                      category: category.category!,
                      types_of_Clothes: category.typesOfClothes!,
                      price: category.price!,
                      items: qty + 1,
                    );

                    setState(() {}); // Refresh UI to update bottom sheet
                  },
                  remove: () {
                    if (qty > 0) {
                      servicesProvider.addServiceCategory(
                        serviceId: selectedService.serviceId!,
                        service: selectedService.service!,
                        duration: selectedService.duration!,
                        description: selectedService.description!,
                        categoryId: category.categoryId!,
                        category: category.category!,
                        types_of_Clothes: category.typesOfClothes!,
                        price: category.price!,
                        items: qty - 1,
                      );

                      if (qty - 1 == 0) {
                        servicesProvider.removeServiceCategory(
                          selectedService.serviceId!,
                          category.categoryId!,
                        );
                      }
                      setState(() {}); // Refresh UI to update bottom sheet
                    }
                  },
                  addFirstTime: () {
                    servicesProvider.addServiceCategory(
                      serviceId: selectedService.serviceId!,
                      service: selectedService.service!,
                      duration: selectedService.duration!,
                      description: selectedService.description!,
                      categoryId: category.categoryId!,
                      category: category.category!,
                      types_of_Clothes: category.typesOfClothes!,
                      price: category.price!,
                      items: 1,
                    );
                    setState(() {}); // Refresh UI to update bottom sheet
                  },
                );
              },
            ),
            const Height(100),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(ServicesProvider servicesProvider) {
    final selectedCategories = servicesProvider.selectedServiceCategories;
    int totalPrice = 0;
    int totalItems = 0;

    for (var serviceEntry in selectedCategories) {
      final categories = serviceEntry['categorys'] as List<dynamic>? ?? [];
      for (var category in categories) {
        final price = int.tryParse(category['category_prices'] ?? '0') ?? 0;
        final items = category['items'] as int? ?? 0;
        totalPrice += price * items;
        totalItems += items;
      }
    }

    // Calculate original price based on selected services
    final servicesList = servicesProvider.servicesList?.data?.service ?? [];
    int originalPrice = 0;
    for (var serviceEntry in selectedCategories) {
      final serviceId = serviceEntry['service_id'] as int?;
      if (serviceId != null) {
        final service = servicesList.firstWhere(
          (service) => service.serviceId == serviceId,
          // orElse: () => null,
        );
        if (service != null && service.original != null) {
          final categories = serviceEntry['categorys'] as List<dynamic>? ?? [];
          int serviceItems = 0;
          for (var category in categories) {
            serviceItems += category['items'] as int? ?? 0;
          }
          originalPrice += service.original! * serviceItems;
        }
      }
    }
    // Use totalPrice if originalPrice is not higher
    originalPrice = originalPrice > totalPrice ? originalPrice : totalPrice;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 81, 81, 81).withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: "₹$totalPrice",
                    fontweights: FontWeight.w500,
                    size: 18,
                  ),
                ],
              ),
              const Height(4),
              CustomText(
                text: "Total Items: $totalItems",
                size: 14,
                color: Colors.black87,
              ),
            ],
          ),
          ContinueButton(
            width: 160,
            text: 'Confirm Booking',
            isValid: selectedCategories.isNotEmpty,
            isLoading: false,
            onTap: () =>
                _confirmBooking(servicesProvider, totalPrice, totalItems),
          ),
        ],
      ),
    );
  }

  void _confirmBooking(
      ServicesProvider servicesProvider, int totalPrice, int totalItems) {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final orderPlaceDetailsProvider =
        Provider.of<OrderPlaceDetailsProvider>(context, listen: false);
    orderPlaceDetailsProvider.resetBooking();
    final defaultAddress = addressProvider.addresses.firstWhere(
      (address) => address.isPrimary == true,
      orElse: () => addressProvider.addresses.isNotEmpty
          ? addressProvider.addresses.first
          : AddressData(addressId: null),
    );

    if (defaultAddress.addressId == null) {
      showToast('Please select an address');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddressScreen()),
      );
      return;
    }

    final String serviceListString = servicesProvider.selectedServiceCategories
        .map((e) => e['service'])
        .join(', ');
    final String orderDetails =
        servicesProvider.selectedServiceCategories.toString();

    orderPlaceDetailsProvider.updateService(
        orderType: 'regular',
        serviceName: serviceListString,
        orderQty: totalItems,
        orderAmount: totalPrice,
        orderDetails: orderDetails,
        addressId: defaultAddress.addressId.toString());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutScreenV3(),
      ),
    );
    showToast('Proceeding to payment');
  }

  Widget _retryWidget(
      ServicesProvider servicesProvider, AddressProvider addressProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: servicesProvider.errorMessage ??
                addressProvider.errorMessage ??
                'An error occurred',
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              servicesProvider.getServices();
              addressProvider.fetchAddresses();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
