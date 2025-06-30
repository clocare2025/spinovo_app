import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spinovo_app/models/timeslot_model.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class DateTimePicker extends StatefulWidget {
  final List<TimeSlot> timeSlots;
  final TimeSlot? selectedDate;
  final String? selectedTimeSlot;
  final String selectedPeriod;
  final int slotCharges;
  final Function(TimeSlot?) onDateSelected;
  final Function(String?) onTimeSlotSelected;
  final Function(String) onPeriodSelected;
  final Function(int) onSlotChargesChanged;

  const DateTimePicker({
    super.key,
    required this.timeSlots,
    this.selectedDate,
    this.selectedTimeSlot,
    required this.selectedPeriod,
    required this.slotCharges,
    required this.onDateSelected,
    required this.onTimeSlotSelected,
    required this.onPeriodSelected,
    required this.onSlotChargesChanged,
  });

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  @override
  Widget build(BuildContext context) {
    final selectedDateSlots = widget.selectedDate?.slot ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionContainer(
          title: "Select date of Pickup",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.timeSlots.map((timeSlot) {
              final now = DateTime.now();
              final today = DateFormat('dd/MM/yyyy').format(now);
              final isCurrentDate = timeSlot.date == today;
              final hasActiveSlots = timeSlot.slot?.any((slot) =>
                      slot.slotTime?.any((slotTime) =>
                          slotTime.isActive == true) ?? false) ?? false;
              return GestureDetector(
                onTap: hasActiveSlots
                    ? () {
                        setState(() {
                          widget.onDateSelected(timeSlot);
                          widget.onTimeSlotSelected(null);
                          widget.onPeriodSelected(
                              isCurrentDate ? (now.hour < 12 ? "AM" : "PM") : "AM");
                        });
                      }
                    : null,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: widget.selectedDate == timeSlot
                        ? const Color(0xFFE9FFEB)
                        : Colors.white,
                    border: Border.all(
                      color: widget.selectedDate == timeSlot
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
                        color: hasActiveSlots
                            ? const Color(0xFF6B8A77)
                            : Colors.grey,
                      ),
                      CustomText(
                        text: timeSlot.date?.split('/')[0] ?? '',
                        size: 14,
                        color: hasActiveSlots ? Colors.black : Colors.grey,
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
          title: "Select time slot of Pickup",
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
                      widget.onPeriodSelected("AM");
                      widget.onTimeSlotSelected(null);
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 50,
                    decoration: BoxDecoration(
                      color: widget.selectedPeriod == "AM"
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'AM',
                        size: 12,
                        color: widget.selectedPeriod == "AM"
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
                      widget.onPeriodSelected("PM");
                      widget.onTimeSlotSelected(null);
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 50,
                    decoration: BoxDecoration(
                      color: widget.selectedPeriod == "PM"
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'PM',
                        size: 12,
                        color: widget.selectedPeriod == "PM"
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          child: widget.selectedDate == null || selectedDateSlots.isEmpty
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
                    final isSelected = widget.selectedTimeSlot == slotTime.time;
                    final isActive = slotTime.isActive == true;
                    final int slotCharge = slotTime.charges!;
                    return GestureDetector(
                      onTap: isActive
                          ? () {
                              setState(() {
                                widget.onSlotChargesChanged(slotCharge);
                                widget.onTimeSlotSelected(slotTime.time);
                              });
                            }
                          : null,
                      child: Stack(
                        clipBehavior: Clip.none,
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
                                        ? const Color.fromARGB(255, 0, 182, 40)
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
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
      ],
    );
  }

  List<SlotTime> _getFilteredSlotTimes(List<Slot> slots) {
    List<SlotTime> allSlotTimes = [];
    for (var slot in slots) {
      if (slot.slotTime != null) allSlotTimes.addAll(slot.slotTime!);
    }
    return allSlotTimes.where((slotTime) {
      final time = slotTime.time?.toUpperCase() ?? '';
      return time.endsWith(widget.selectedPeriod);
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