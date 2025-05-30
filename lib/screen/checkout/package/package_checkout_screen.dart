import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/models/package_model.dart';
import 'package:spinovo_app/models/services_model.dart';
import 'package:spinovo_app/models/timeslot_model.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/providers/services_provider.dart';
import 'package:spinovo_app/providers/timeslot_provider.dart';
import 'package:spinovo_app/screen/address/address_screen.dart';
import 'package:spinovo_app/screen/checkout/checkout_appbar.dart';
import 'package:spinovo_app/screen/checkout/package/package_payment_screen.dart';
import 'package:spinovo_app/screen/checkout/payment_screen.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class PackageCheckoutScreen extends StatefulWidget {
  final Package package;

  const PackageCheckoutScreen({
    super.key,
    required this.package,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PackageCheckoutScreenState createState() => _PackageCheckoutScreenState();
}

class _PackageCheckoutScreenState extends State<PackageCheckoutScreen> {
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
          _selectedPeriod = now.hour < 12 ? "AM" : "PM";
          final today = DateFormat('dd/MM/yyyy').format(now);
          final timeSlots = timeslotProvider.timeSlot?.data?.timeSlot ?? [];
          _selectedDate =
              timeSlots.firstWhereOrNull((slot) => slot.date == today);
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
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: timeslotProvider.errorMessage ??
                                  addressProvider.errorMessage!,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                timeslotProvider.getTimeSlot();

                                addressProvider.fetchAddresses();
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      )
                    : _buildBody(timeslotProvider),
            bottomSheet: _buildBottomSheet(),
          );
        },
      ),
    );
  }

  Widget _buildBody(
      TimeslotProvider timeslotProvider,) {
    final timeSlots = timeslotProvider.timeSlot?.data?.timeSlot ?? [];
    final selectedDateSlots = _selectedDate?.slot ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Height(15),
            _buildSectionContainer(
              title: "Select date of service",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: timeSlots.map((timeSlot) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = timeSlot;
                        _selectedTimeSlot = null;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: _selectedDate == timeSlot
                            ? const Color(0xFFE9FFEB)
                            : Colors.white,
                        border: Border.all(
                          color: _selectedDate == timeSlot
                              ? const Color(0xFF33C362)
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: timeSlot.day ?? '',
                            size: 12,
                            color: const Color(0xFF6B8A77),
                          ),
                          CustomText(
                            text: timeSlot.date?.split('/')[0] ?? '',
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Height(15),
            _buildSectionContainer(
              title: "Select time slot of service",
              widget: Container(
                width: 110,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEEEEEE), width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = "AM";
                          _selectedTimeSlot = null;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          color: _selectedPeriod == "AM"
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'AM',
                            size: 12,
                            color: _selectedPeriod == "AM"
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const Widths(5),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = "PM";
                          _selectedTimeSlot = null;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          color: _selectedPeriod == "PM"
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'PM',
                            size: 12,
                            color: _selectedPeriod == "PM"
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: _selectedDate == null || selectedDateSlots.isEmpty
                  ? Center(
                      child: CustomText(
                          text: "Select a date to view time slots",
                          color: Colors.grey),
                    )
                  : GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 8,
                      children: _getFilteredSlotTimes(selectedDateSlots)
                          .map((slotTime) {
                        final isSelected = _selectedTimeSlot == slotTime.time;
                        final isActive = slotTime.isActive == true;
                        final int slotCharge = slotTime.charges!;
                        return GestureDetector(
                          onTap: isActive
                              ? () {
                                  setState(() {
                                    slotCharges = slotCharge;
                                    _selectedTimeSlot = slotTime.time;
                                  });
                                }
                              : null,
                          child: Stack(
                            clipBehavior: Clip
                                .none, // Allows the label to overflow the container
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isSelected && isActive
                                      ? const Color(0xFFE9FFEB)
                                      : Colors.white,
                                  border: Border.all(
                                    color: isSelected && isActive
                                        ? const Color(0xFF33C362)
                                        : Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: CustomText(
                                    text: slotTime.time ?? '',
                                    fontweights: isSelected && isActive
                                        ? FontWeight.w500
                                        : (isActive
                                            ? FontWeight.normal
                                            : FontWeight.w100),
                                    color: isActive
                                        ? (isSelected
                                            ? const Color.fromARGB(
                                                255, 0, 182, 40)
                                            : Colors.black87)
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              if (slotCharge != 0)
                                Positioned(
                                  top: -8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFFEEFD2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    child: CustomText(
                                      text: "EXTRA ₹$slotCharge",
                                      size: 9,
                                      color: const Color(0xFF956A1C),
                                      fontweights: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const Height(100),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
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
                text: "₹${widget.package.originalPrices + slotCharges}",
                decoration: TextDecoration.lineThrough,
                size: 15,
                color: Colors.grey,
              ),
              const Widths(5),
              CustomText(
                text: "₹${widget.package.discountPrices + slotCharges}",
                fontweights: FontWeight.w500,
                size: 18,
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
      String serviceList = widget.package.services.map((element) => element.serviceName).join(' + ');      
      final bookingDetails = {
        'order_type': 'package',
        'service_id':  widget.package.packageId,
        'service_name': serviceList,
        'garment_qty': widget.package.noOfClothes,
        'garment_original_amount':  widget.package.originalPrices,
        'garment_discount_amount':   widget.package.discountPrices,
        'order_amount': widget.package.discountPrices,
        'service_charges': widget.package.discountPrices,
        'slot_charges': slotCharges,
        'booking_date': _selectedDate!.date,
        'booking_time': '$_selectedTimeSlot $_selectedPeriod',
        'address_id': defaultAddress.addressId,
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(bookingDetails: bookingDetails,),
        ),
      );
      showToast('Proceeding to payment');
    } else {
      showToast(
          'Please select date, time slot, service, and a valid quantity (min )');
    }
  }

  List<SlotTime> _getFilteredSlotTimes(List<Slot> slots) {
    List<SlotTime> allSlotTimes = [];
    for (var slot in slots) {
      if (slot.slotTime != null) allSlotTimes.addAll(slot.slotTime!);
    }
    return allSlotTimes.where((slotTime) {
      final time = slotTime.time?.toUpperCase() ?? '';
      return time.endsWith(_selectedPeriod);
    }).toList();
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
