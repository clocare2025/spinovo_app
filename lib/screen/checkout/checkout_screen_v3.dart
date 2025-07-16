import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/models/timeslot_model.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/providers/order_place_provider.dart';
import 'package:spinovo_app/providers/timeslot_provider.dart';
import 'package:spinovo_app/screen/address/address_screen.dart';
import 'package:spinovo_app/screen/checkout/widgets/checkout_appbar.dart';
import 'package:spinovo_app/screen/checkout/widgets/slot_picker.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/retry_widget.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

import 'payment_screen.dart';

class CheckoutScreenV3 extends StatefulWidget {
  const CheckoutScreenV3({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutScreenV3State createState() => _CheckoutScreenV3State();
}

class _CheckoutScreenV3State extends State<CheckoutScreenV3> {
  TimeSlot? _selectedDate;
  String? _selectedTimeSlot;
  String _selectedPeriod = "AM";
  int slotCharges = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final timeslotProvider =
          Provider.of<TimeslotProvider>(context, listen: false);
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);

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

      // Fetch addresses
      addressProvider.fetchAddresses();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Provider.of<TimeslotProvider>(context)),
        ChangeNotifierProvider.value(
            value: Provider.of<AddressProvider>(context)),
      ],
      child: Consumer2<TimeslotProvider, AddressProvider>(
        builder: (context, timeslotProvider, addressProvider, child) {
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
            body: timeslotProvider.isLoading || addressProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : timeslotProvider.errorMessage != null ||
                        addressProvider.errorMessage != null
                    ? RetryWidget(
                        msg: timeslotProvider.errorMessage ??
                            addressProvider.errorMessage!,
                        onTap: () {
                          timeslotProvider.getTimeSlot();

                          addressProvider.fetchAddresses();
                        },
                      )
                    : _buildBody(timeslotProvider),
            bottomSheet: _buildBottomSheet(),
          );
        },
      ),
    );
  }

  Widget _buildBody(TimeslotProvider timeslotProvider) {
    final timeSlots = timeslotProvider.timeSlot?.data?.timeSlot ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

  Widget _buildBottomSheet() {
    final orderPlaceDetailsProvider =
        Provider.of<OrderPlaceDetailsProvider>(context);
    // Access the booking data
    final booking = orderPlaceDetailsProvider.booking;
    // Extract orderQty and orderAmount
    final int totalItems = booking.orderQty!;
    final int totalPrice = booking.orderAmount!;

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
                    text: "₹${totalPrice + slotCharges}",
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
            isValid: _selectedDate != null && _selectedTimeSlot != null,
            isLoading: false,
            onTap: () => _confirmBooking(),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final orderPlaceDetailsProvider =
        Provider.of<OrderPlaceDetailsProvider>(context, listen: false);
    final defaultAddress = addressProvider.addresses.firstWhere(
      (address) => address.isPrimary == true,
      orElse: () => addressProvider.addresses.isNotEmpty
          ? addressProvider.addresses.first
          : AddressData(addressId: null),
    );

    if (_selectedDate != null && _selectedTimeSlot != null) {
      if (defaultAddress.addressId == null) {
        showToast('Please select an address');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddressScreen()),
        );
        return;
      }

      orderPlaceDetailsProvider.updateSlot(
          slotCharges: slotCharges,
          bookingDate: _selectedDate!.date.toString(),
          bookingTime: _selectedTimeSlot.toString());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentScreen(),
        ),
      );

      // Access the booking data
      final booking = orderPlaceDetailsProvider.booking;
      print('booking ${booking.orderType}');
      print('booking ${booking.serviceName}');
      print('booking ${booking.orderQty}');
      print('booking ${booking.orderAmount}');
      print('booking ${booking.orderDetails}');
      print('booking ${booking.addressId}');
      print('booking ${booking.slotCharges}');
      print('booking ${booking.bookingDate}');
      print('booking ${booking.bookingTime}');
      showToast('Proceeding to payment');
    } else {
      showToast(
          'Please select date, time slot, service, and a valid quantity )');
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
