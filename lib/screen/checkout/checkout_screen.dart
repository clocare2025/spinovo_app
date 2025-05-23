import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/models/services_model.dart';
import 'package:spinovo_app/models/timeslot_model.dart';
import 'package:spinovo_app/providers/services_provider.dart';
import 'package:spinovo_app/providers/timeslot_provider.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final String serviceId; // Required service_id to filter services
  const CheckoutScreen({super.key, required this.serviceId});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // State variables
  TimeSlot? _selectedDate;
  String? _selectedTimeSlot;
  String _selectedPeriod = "AM";
  int? _selectedServiceQtyIndex;

  @override
  void initState() {
    super.initState();
    // Fetch timeslots and services after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timeslotProvider =
          Provider.of<TimeslotProvider>(context, listen: false);
      final servicesProvider =
          Provider.of<ServicesProvider>(context, listen: false);

      // Fetch timeslots
      timeslotProvider.getTimeSlot().then((_) {
        if (mounted) {
          setState(() {
            // Set default AM/PM based on current time (02:00 PM IST)
            final now = DateTime.now();
            _selectedPeriod = now.hour < 12 ? "AM" : "PM";

            // Set default date to today if available
            final today = DateFormat('dd/MM/yyyy').format(now);
            final timeSlots = timeslotProvider.timeSlot?.data?.timeSlot ?? [];
            _selectedDate =
                timeSlots.firstWhereOrNull((slot) => slot.date == today);
          });
        }
      });

      // Fetch services
      servicesProvider.getServices().then((_) {
        if (mounted) {
          setState(() {
            // Set default service quantity index to 0 if available
            final services = servicesProvider.servicesList?.data?.service
                ?.firstWhereOrNull((service) =>
                    service.serviceId.toString() == widget.serviceId);
            if (services != null &&
                services.pricesByQty != null &&
                services.pricesByQty!.isNotEmpty) {
              _selectedServiceQtyIndex = 0;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Provider.of<TimeslotProvider>(context)),
        ChangeNotifierProvider.value(
            value: Provider.of<ServicesProvider>(context)),
      ],
      child: Consumer2<TimeslotProvider, ServicesProvider>(
        builder: (context, timeslotProvider, servicesProvider, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColor.textColor),
                onPressed: () => context.pop(),
              ),
              title: CustomText(
                text: "Home | i-hub Gujrat",
                size: 15,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Placeholder for "Change" action (e.g., change address)
                  },
                  child: CustomText(
                    text: "Change",
                    size: 15,
                    color: AppColor.appbarColor,
                  ),
                ),
              ],
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: timeslotProvider.isLoading || servicesProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : timeslotProvider.errorMessage != null ||
                        servicesProvider.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: timeslotProvider.errorMessage ??
                                  servicesProvider.errorMessage!,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                timeslotProvider.getTimeSlot();
                                servicesProvider.getServices();
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
    final selectedDateSlots = _selectedDate?.slot ?? [];
    final service = servicesProvider.servicesList?.data?.service
        ?.firstWhereOrNull(
            (service) => service.serviceId.toString() == widget.serviceId);
    final pricesByQty = service?.pricesByQty ?? [];

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
            // Service Selection Section
            _buildSectionContainer(
              title: "Select number of Clothes",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pricesByQty.isEmpty
                      ? Center(
                          child: CustomText(
                            text: "No service quantities available",
                            color: Colors.grey,
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: pricesByQty.asMap().entries.map((entry) {
                              int index = entry.key;
                              PricesByQty qty = entry.value;
                              final qtyOriginalPrice =
                                  (qty.qty ?? 0) * (service?.original ?? 0);
                              final qtyDiscountedPrice =
                                  (qty.qty ?? 0) * (service?.discounted ?? 0);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedServiceQtyIndex = index;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12, right: 20, left: 20),
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
                                        text: "${qty.qty ?? 0} Clothes",
                                        fontweights: FontWeight.w500,
                                      ),
                                      const Height(5),
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
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const Height(15),
            // Date Selection Section
            _buildSectionContainer(
              title: "Select date of service",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: timeSlots.map((timeSlot) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = timeSlot;
                        _selectedTimeSlot = null; // Reset time slot
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
            // Time Selection Section
            _buildSectionContainer(
              title: "Select time slot of service",
              widget: Container(
                width: 110,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFEEEEEE), width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = "AM";
                          _selectedTimeSlot = null; // Reset time slot
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
                          _selectedTimeSlot = null; // Reset time slot
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
                        color: Colors.grey,
                      ),
                    )
                  : GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: _getFilteredSlotTimes(selectedDateSlots)
                          .map((slotTime) {
                        final isSelected = _selectedTimeSlot == slotTime.time;
                        final isActive = slotTime.isActive == true;

                        return GestureDetector(
                          onTap: isActive
                              ? () {
                                  setState(() {
                                    _selectedTimeSlot = slotTime.time;
                                  });
                                }
                              : null, // Disable tap for inactive slots
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected && isActive
                                  ? Color(0xFFE9FFEB)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected && isActive
                                    ? Color(0xFF33C362)
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
                                        ? Color.fromARGB(255, 0, 182, 40)
                                        : Colors.black87)
                                    : Colors.grey,
                              ),
                            ),
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

  Widget _buildBottomSheet(ServicesProvider servicesProvider) {
    final service = servicesProvider.servicesList?.data?.service
        ?.firstWhereOrNull(
            (service) => service.serviceId.toString() == widget.serviceId);
    final selectedQty = _selectedServiceQtyIndex != null && service != null
        ? service.pricesByQty![_selectedServiceQtyIndex!]
        : null;
    final bottomOriginalPrice = selectedQty != null
        ? (selectedQty.qty ?? 0) * (service?.original ?? 0)
        : 123;
    final bottomDiscountedPrice = selectedQty != null
        ? (selectedQty.qty ?? 0) * (service?.discounted ?? 0)
        : 150;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 81, 81, 81).withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, -2),
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
                text: "₹$bottomOriginalPrice",
                decoration: TextDecoration.lineThrough,
                size: 15,
              ),
              const Widths(5),
              CustomText(
                text: "₹$bottomDiscountedPrice",
                fontweights: FontWeight.w500,
                size: 18,
              ),
            ],
          ),
          ContinueButton(
            width: 160,
            text: 'Confirm Booking',
            isValid: true,
            isLoading: false,
            onTap: () => _confirmBooking(servicesProvider),
          ),
        ],
      ),
    );
  }

  void _confirmBooking(ServicesProvider servicesProvider) {
    final service = servicesProvider.servicesList?.data?.service
        ?.firstWhereOrNull(
            (service) => service.serviceId.toString() == widget.serviceId);
    final selectedQty = _selectedServiceQtyIndex != null && service != null
        ? service.pricesByQty![_selectedServiceQtyIndex!]
        : null;

    if (_selectedDate != null &&
        _selectedTimeSlot != null &&
        selectedQty != null) {

          
      var checkoutData = {
        'date': _selectedDate!.date,
        'day': _selectedDate!.day,
        'time': _selectedTimeSlot,
        'period': _selectedPeriod,
        'service_id': widget.serviceId,
        'service_name': service?.service,
        'service_qty': selectedQty.qty,
        'original_price': (selectedQty.qty ?? 0) * (service?.original ?? 0),
        'discounted_price': (selectedQty.qty ?? 0) * (service?.discounted ?? 0),
      };

      // context.go('/payment', extra: {
      //   'date': _selectedDate!.date,
      //   'day': _selectedDate!.day,
      //   'time': _selectedTimeSlot,
      //   'period': _selectedPeriod,
      //   'service_id': widget.serviceId,
      //   'service_name': service?.service,
      //   'service_qty': selectedQty.qty,
      //   'original_price': (selectedQty.qty ?? 0) * (service?.original ?? 0),
      //   'discounted_price': (selectedQty.qty ?? 0) * (service?.discounted ?? 0),
      // });
      showToast('Booking confirmed');
    } else {
      showToast('Please select date, time slot, and service quantity');
    }
  }

  List<SlotTime> _getFilteredSlotTimes(List<Slot> slots) {
    // Combine all slot_time entries from all slots, filter by AM/PM
    List<SlotTime> allSlotTimes = [];
    for (var slot in slots) {
      if (slot.slotTime != null) {
        allSlotTimes.addAll(slot.slotTime!);
      }
    }
    return allSlotTimes.where((slotTime) {
      final time = slotTime.time?.toUpperCase() ?? '';
      return time.endsWith(_selectedPeriod);
    }).toList();
  }

  // Helper method to build section containers
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
              CustomText(
                text: title,
                size: 14,
                fontweights: FontWeight.w500,
              ),
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
