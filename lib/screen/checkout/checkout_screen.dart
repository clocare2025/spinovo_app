import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/models/services_model.dart';
import 'package:spinovo_app/models/timeslot_model.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/providers/services_provider.dart';
import 'package:spinovo_app/providers/timeslot_provider.dart';
import 'package:spinovo_app/screen/address/address_screen.dart';
import 'package:spinovo_app/screen/checkout/widgets/checkout_appbar.dart';
import 'package:spinovo_app/screen/checkout/payment_screen.dart';
import 'package:spinovo_app/screen/checkout/widgets/slot_picker.dart';
import 'package:spinovo_app/utiles/constants.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/custom_textfield.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final int serviceId;
  const CheckoutScreen({super.key, required this.serviceId});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TimeSlot? _selectedDate;
  String? _selectedTimeSlot;
  String _selectedPeriod = "AM";
  int? _selectedServiceId;
  int? _selectedServiceQtyIndex;
  final TextEditingController noOfClothe = TextEditingController();
  String? _qtyError;
  int slotCharges = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final timeslotProvider = Provider.of<TimeslotProvider>(context, listen: false);
      final servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);

      // Fetch time slots
      await timeslotProvider.getTimeSlot();
      if (mounted) {
        setState(() {
          final now = DateTime.now();
          final today = DateFormat('dd/MM/yyyy').format(now);
          final timeSlots = timeslotProvider.timeSlot?.data?.timeSlot ?? [];

          // Check if current date has active slots
          final currentDateSlot =
              timeSlots.firstWhereOrNull((slot) => slot.date == today);
          bool hasActiveSlots = false;
          if (currentDateSlot != null && currentDateSlot.slot != null) {
            hasActiveSlots = currentDateSlot.slot!.any((slot) =>
                slot.slotTime?.any((slotTime) => slotTime.isActive == true) ??
                false);
          }

          // Select current date if it has active slots, otherwise select the next available date
          if (hasActiveSlots) {
            _selectedDate = currentDateSlot;
            _selectedPeriod = now.hour < 12 ? "AM" : "PM";
          } else {
            _selectedDate = timeSlots.firstWhereOrNull((slot) =>
                slot.date != today &&
                (slot.slot?.any((s) =>
                        s.slotTime?.any((st) => st.isActive == true) ??
                        false) ??
                    false));
            _selectedPeriod = "AM"; // Default to AM for non-current dates
          }
        });
      }

      // Fetch services
      await servicesProvider.getServices();
      if (mounted) {
        setState(() {
          final services = servicesProvider.servicesList?.data?.service;
          if (services != null && services.isNotEmpty) {
            _selectedServiceId = services
                    .firstWhereOrNull(
                      (s) => s.serviceId == widget.serviceId,
                    )
                    ?.serviceId ??
                services.first.serviceId;

            final selectedService = services.firstWhereOrNull(
              (s) => s.serviceId == _selectedServiceId,
            );

            if (selectedService?.pricesByQty != null &&
                selectedService!.pricesByQty!.isNotEmpty) {
              _selectedServiceQtyIndex = 0;
              noOfClothe.text =
                  selectedService.pricesByQty!.first.qty.toString();
            } else {
              noOfClothe.text = selectedService?.minQty?.toString() ?? '';
            }
          }
        });
      }

      // Fetch addresses
      addressProvider.fetchAddresses();
    });
  }

  @override
  void dispose() {
    noOfClothe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Provider.of<TimeslotProvider>(context)),
        ChangeNotifierProvider.value(
            value: Provider.of<ServicesProvider>(context)),
        ChangeNotifierProvider.value(
            value: Provider.of<AddressProvider>(context)),
      ],
      child: Consumer3<TimeslotProvider, ServicesProvider, AddressProvider>(
        builder: (context, timeslotProvider, servicesProvider, addressProvider,
            child) {
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
            body: timeslotProvider.isLoading ||
                    servicesProvider.isLoading ||
                    addressProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : timeslotProvider.errorMessage != null ||
                        servicesProvider.errorMessage != null ||
                        addressProvider.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: timeslotProvider.errorMessage ??
                                  servicesProvider.errorMessage ??
                                  addressProvider.errorMessage!,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                timeslotProvider.getTimeSlot();
                                servicesProvider.getServices();
                                addressProvider.fetchAddresses();
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      )
                    : _buildBody(timeslotProvider, servicesProvider),
            bottomSheet: _buildBottomSheet(servicesProvider),
          );
        },
      ),
    );
  }

  Widget _buildBody(
      TimeslotProvider timeslotProvider, ServicesProvider servicesProvider) {
    final timeSlots = timeslotProvider.timeSlot?.data?.timeSlot ?? [];
    final servicesList = servicesProvider.servicesList?.data?.service ?? [];
    final selectedService = servicesList
        .firstWhereOrNull((service) => service.serviceId == _selectedServiceId);
    final pricesByQty = selectedService?.pricesByQty ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Choose service details",
              size: 16,
              fontweights: FontWeight.w500,
            ),
            const Height(15),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  servicesList.isEmpty
                      ? Center(
                          child: CustomText(
                              text: "No services available",
                              color: Colors.grey),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: servicesList.asMap().entries.map((entry) {
                              int index = entry.key;
                              var service = entry.value;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedServiceId = service.serviceId;
                                    _selectedServiceQtyIndex =
                                        service.pricesByQty != null &&
                                                service.pricesByQty!.isNotEmpty
                                            ? 0
                                            : null;
                                    noOfClothe.text = service.pricesByQty !=
                                                null &&
                                            service.pricesByQty!.isNotEmpty
                                        ? service.pricesByQty!.first.qty
                                            .toString()
                                        : (service.minQty?.toString() ?? '');
                                    _qtyError = null;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 18),
                                  decoration: BoxDecoration(
                                    color:
                                        _selectedServiceId == service.serviceId
                                            ? const Color(0xFFE9FFEB)
                                            : Colors.white,
                                    border: Border.all(
                                      color: _selectedServiceId ==
                                              service.serviceId
                                          ? const Color(0xFF33C362)
                                          : Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText(
                                    text: service.service!,
                                    fontweights: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                  const Height(15),
                  if (selectedService != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: selectedService.description ?? '',
                            size: 12,
                            color: Colors.black87,
                          ),
                          const Height(6),
                          CustomText(
                              text:
                                  "Service duration: ${selectedService.duration}",
                              size: 12,
                              color: const Color(0xFF33C362)),
                          const Height(6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text:
                                    "Original Price: ₹${selectedService.original}",
                                size: 12,
                                color: Colors.black87,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.black87,
                              ),
                              CustomText(
                                  text:
                                      "Discounted Price: ₹${selectedService.discounted}",
                                  size: 12,
                                  color: const Color(0xFF33C362)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ],
              ),
            ),
            const Height(15),
            _buildSectionContainer(
              title: "Select package & Enter no of Clothes",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextField(
                    height: 45,
                    controller: noOfClothe,
                    hintText: 'Enter number of clothes',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(100),
                    ],
                    onChanged: (value) {
                      setState(() {
                        final qty = int.tryParse(value);
                        if (qty == null ||
                            qty < (selectedService?.minQty ?? 0)) {
                          _qtyError =
                              'Minimum quantity is ${selectedService?.minQty ?? 0}';
                          _selectedServiceQtyIndex = null;
                        } else {
                          _qtyError = null;
                          _selectedServiceQtyIndex =
                              pricesByQty.indexWhere((q) => q.qty == qty);
                        }
                      });
                    },
                  ),
                  if (_qtyError != null) ...[
                    const Height(5),
                    CustomText(text: _qtyError!, color: Colors.red, size: 12),
                  ],
                  const Height(10),
                  if (noOfClothe.text.isNotEmpty && _qtyError == null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            text: "Total: ",
                            size: 12,
                            fontweights: FontWeight.w500),
                        CustomText(
                          text:
                              "₹${(int.tryParse(noOfClothe.text) ?? 0) * (selectedService?.original ?? 0)}",
                          decoration: TextDecoration.lineThrough,
                          decorationColor: const Color(0xFFBFC3CF),
                          size: 12,
                          color: const Color(0xFFBFC3CF),
                          fontweights: FontWeight.w500,
                        ),
                        const Widths(5),
                        CustomText(
                          text:
                              "₹${(int.tryParse(noOfClothe.text) ?? 0) * (selectedService?.discounted ?? 0)}",
                          size: 12,
                          fontweights: FontWeight.w500,
                        ),
                      ],
                    ),
                    const Height(10),
                  ],
                  pricesByQty.isEmpty
                      ? Center(
                          child: CustomText(
                              text: "No service quantities available",
                              color: Colors.grey),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: pricesByQty.asMap().entries.map((entry) {
                              int index = entry.key;
                              PricesByQty qty = entry.value;
                              final qtyOriginalPrice = (qty.qty ?? 0) *
                                  (selectedService?.original ?? 0);
                              final qtyDiscountedPrice = (qty.qty ?? 0) *
                                  (selectedService?.discounted ?? 0);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedServiceQtyIndex = index;
                                    noOfClothe.text = (qty.qty ?? 0).toString();
                                    _qtyError = null;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: _selectedServiceQtyIndex == index
                                        ? const Color(0xFFE9FFEB)
                                        : Colors.white,
                                    border: Border.all(
                                      color: _selectedServiceQtyIndex == index
                                          ? const Color(0xFF33C362)
                                          : Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      CustomText(
                                        text:
                                            "${qty.qty ?? 0} ${selectedService!.label}",
                                        fontweights: FontWeight.w500,
                                      ),
                                      const Height(2),
                                      Row(
                                        children: [
                                          CustomText(
                                            text: "₹$qtyOriginalPrice",
                                            color: const Color(0xFFBFC3CF),
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationColor:
                                                const Color(0xFFBFC3CF),
                                            size: 12,
                                          ),
                                          const Widths(8),
                                          CustomText(
                                            text: "₹$qtyDiscountedPrice",
                                            fontweights: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                  const Height(10),
                ],
              ),
            ),
            const Height(15),
            DateTimePicker(
              timeSlots: timeSlots,
              selectedDate: _selectedDate,
              selectedTimeSlot: _selectedTimeSlot,
              selectedPeriod: _selectedPeriod,
              slotCharges: slotCharges,
              onDateSelected: (TimeSlot? timeSlot) {
                setState(() {
                  _selectedDate = timeSlot;
                });
              },
              onTimeSlotSelected: (String? timeSlot) {
                setState(() {
                  _selectedTimeSlot = timeSlot;
                });
              },
              onPeriodSelected: (String period) {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              onSlotChargesChanged: (int charges) {
                setState(() {
                  slotCharges = charges;
                });
              },
            ),
            const Height(100),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(ServicesProvider servicesProvider) {
    final selectedService = servicesProvider.servicesList?.data?.service
        ?.firstWhereOrNull(
            (service) => service.serviceId == _selectedServiceId);
    final enteredQty = int.tryParse(noOfClothe.text);
    final isValidQty =
        enteredQty != null && enteredQty >= (selectedService?.minQty ?? 0);
    final serviceOriginalCharge = isValidQty
        ? enteredQty! * (selectedService?.original ?? 0)
        : (selectedService?.minQty ?? 0) * (selectedService?.original ?? 0);
    final serviceDiscountCharge = isValidQty
        ? enteredQty! * (selectedService?.discounted ?? 0)
        : (selectedService?.minQty ?? 0) * (selectedService?.discounted ?? 0);
    final slotCharge = 0;
    final originalPrice = serviceOriginalCharge + slotCharge;
    final discountedPrice = serviceDiscountCharge + slotCharge;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: "₹${originalPrice + slotCharges}",
                decoration: TextDecoration.lineThrough,
                size: 15,
                color: Colors.grey,
              ),
              const Widths(5),
              CustomText(
                text: "₹${discountedPrice + slotCharges}",
                fontweights: FontWeight.w500,
                size: 18,
              ),
            ],
          ),
          ContinueButton(
            width: 160,
            text: 'Confirm Booking',
            isValid: isValidQty &&
                _selectedDate != null &&
                _selectedTimeSlot != null,
            isLoading: false,
            onTap: () => _confirmBooking(servicesProvider),
          ),
        ],
      ),
    );
  }

  void _confirmBooking(ServicesProvider servicesProvider) {
    final selectedService = servicesProvider.servicesList?.data?.service
        ?.firstWhereOrNull(
            (service) => service.serviceId == _selectedServiceId);
    final enteredQty = int.tryParse(noOfClothe.text);
    final isValidQty =
        enteredQty != null && enteredQty >= (selectedService?.minQty ?? 0);
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final defaultAddress = addressProvider.addresses.firstWhere(
      (address) => address.isPrimary == true,
      orElse: () => addressProvider.addresses.isNotEmpty
          ? addressProvider.addresses.first
          : AddressData(addressId: null),
    );

    if (_selectedDate != null &&
        _selectedTimeSlot != null &&
        selectedService != null &&
        isValidQty) {
      if (defaultAddress.addressId == null) {
        showToast('Please select an address');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddressScreen()),
        );
        return;
      }
      final bookingDetails = {
        'order_type': 'regular',
        'service_id': _selectedServiceId,
        'service_name': selectedService.service,
        'garment_qty': enteredQty,
        'garment_original_amount': enteredQty * (selectedService.original ?? 0),
        'garment_discount_amount':
            enteredQty * (selectedService.discounted ?? 0),
        'service_charges': enteredQty * (selectedService.discounted ?? 0),
        'slot_charges': slotCharges,
        'handling_charges': AppConstants.handlingCharges,
        'tip_amount': 0,
        'order_amount': enteredQty * (selectedService.discounted ?? 0),
        'total_billing': enteredQty * (selectedService.discounted ?? 0) +
            AppConstants.handlingCharges,
        'payment_mode': "Online",
        'payment_status': "Paid",
        'booking_date': _selectedDate!.date,
        'booking_time': '$_selectedTimeSlot',
        'address_id': defaultAddress.addressId,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(bookingDetails: bookingDetails),
        ),
      );
      showToast('Proceeding to payment');
    } else {
      showToast(
          'Please select date, time slot, service, and a valid quantity (min ${selectedService?.minQty ?? 0})');
    }
  }

  Widget _buildSectionContainer({
    required String title,
    required Widget child,
    Widget? widget,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(text: title, size: 14, fontweights: FontWeight.w500),
              if (widget != null) widget,
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}
