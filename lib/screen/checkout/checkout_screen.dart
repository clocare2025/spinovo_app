import 'package:flutter/material.dart';
import 'package:spinovo_app/screen/checkout/payment_screen.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/utiles/designe.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // State variables
  Map<String, String> selectedDate = {};
  int selectedDurationIndex = 0;
  String selectedTimeSlot = "";
  String selectedPeriod = "AM";

  // Data lists
  // final List<String> dates = ["TODAY", "WED", "THU", "FRI"];
  final List<Map<String, String>> dates = [
    {
      'day': "TODAY",
      'date': "22/05/2025",
    },
    {
      'day': "FRI",
      'date': "23/05/2025",
    },
    {
      'day': "SAT",
      'date': "24/05/2025",
    },
    {
      'day': "SUN",
      'date': "25/05/2025",
    },
  ];
  final List<Map<String, dynamic>> durations = [
    {"duration": "60 mins", "original": 200, "discounted": 169},
    {"duration": "90 mins", "original": 300, "discounted": 255},
    {"duration": "120 mins", "original": 400, "discounted": 335},
  ];
  final List<String> timeSlots = [
    "12:00",
    "12:30",
    "01:00",
    "01:30",
    "02:00",
    "02:30",
    "03:00",
    "03:30",
    "04:00",
    "04:30",
    "05:00",
    "05:30",
    "06:00",
    "06:30",
    "07:00"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColor.textColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: CustomText(
            text: "Home | i-hub Gujrat",
            size: 15,
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Placeholder for "Change" action
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
        body: SingleChildScrollView(
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
                // Date Selection Section
                _buildSectionContainer(
                  title: "Select date of service",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: dates.map((date) {
                      //  print('vvvvvvvvvv ${date}');
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            print('vvvvvvvvvv ${date}');
                            selectedDate = date;
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: customDateDecoration(selectedDate, date),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                text: date['day']!,
                                size: 12,
                                color: const Color(0xFF6B8A77),
                              ),
                              CustomText(
                                text: date['date']!.split("/")[0],
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

                // Duration Selection Section
                _buildSectionContainer(
                  title: "Select number of garment",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: durations.asMap().entries.map((entry) {
                          int index = entry.key;
                          var duration = entry.value;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDurationIndex = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration:
                                  customDateDecoration(selectedDate, index),
                              child: Column(
                                children: [
                                  CustomText(
                                    text: "10 Clothes",
                                    fontweights: FontWeight.w400,
                                  ),
                                  const Height(5),
                                  Row(
                                    children: [
                                      CustomText(
                                        text: "₹150",
                                        color: const Color(0xFFBFC3CF),
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor:
                                            const Color(0xFFBFC3CF),
                                        size: 12,
                                      ),
                                      const Widths(8),
                                      CustomText(
                                        text: "₹120",
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          // Placeholder for hourly booking action
                        },
                        child: Text(
                          "Book hourly & avail multiple services together",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
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
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFFEEEEEE), width: 2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedPeriod = "AM";
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 50,
                            decoration: BoxDecoration(
                              color: selectedPeriod == "AM"
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CustomText(
                                text: 'AM',
                                size: 12,
                                color: selectedPeriod == "AM"
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
                              selectedPeriod = "PM";
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 50,
                            decoration: BoxDecoration(
                              color: selectedPeriod == "PM"
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CustomText(
                                text: 'PM',
                                size: 12,
                                color: selectedPeriod == "PM"
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: timeSlots.map((time) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTimeSlot = time;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedTimeSlot == time
                                ? Color(0xFFEDE7F6)
                                : Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              time,
                              style: TextStyle(
                                color: selectedTimeSlot == time
                                    ? Color(0xFF6200EE)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Height(15),

                // Bottom Action Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "₹${durations[selectedDurationIndex]['original']} ",
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          TextSpan(
                            text:
                                "₹${durations[selectedDurationIndex]['discounted']}",
                            style: TextStyle(
                              color: Color(0xFF6200EE),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedDate.isNotEmpty &&
                            selectedDurationIndex >= 0 &&
                            selectedTimeSlot.isNotEmpty) {
                          print("Booking Confirmed:");
                          print("Date: $selectedDate");
                          print(
                              "Duration: ${durations[selectedDurationIndex]['duration']}");
                          print("Time: $selectedTimeSlot $selectedPeriod");
                          print(
                              "Price: ₹${durations[selectedDurationIndex]['discounted']}");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Please select all options")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6200EE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Confirm booking",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 81, 81, 81).withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: const Offset(0, -2), // Upward shadow
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
                      text: "₹${durations[selectedDurationIndex]['original']} ",
                      decoration: TextDecoration.lineThrough,
                      size: 15,
                    ),
                    const Widths(5),
                    CustomText(
                      text:
                          "₹${durations[selectedDurationIndex]['discounted']}",
                      fontweights: FontWeight.w500,
                      size: 18,
                    ),
                  ],
                ),
                ContinueButton(
                  // height: 45,
                  width: 160,
                  text: 'Confirm Booking',
                  isValid: true,
                  isLoading: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentScreen()),
                    );
                    if (selectedDate.isNotEmpty &&
                        selectedDurationIndex >= 0 &&
                        selectedTimeSlot.isNotEmpty) {
                      print("Booking Confirmed:");
                      print("Date: $selectedDate");
                      print(
                          "Duration: ${durations[selectedDurationIndex]['duration']}");
                      print("Time: $selectedTimeSlot $selectedPeriod");
                      print(
                          "Price: ₹${durations[selectedDurationIndex]['discounted']}");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select all options")),
                      );
                    }
                  },
                ),
              ],
            )));
  
  
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
          const SizedBox(height: 15), // replace Height(15) if it's not defined
          child,
        ],
      ),
    );
  }
}
