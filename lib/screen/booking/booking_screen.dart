import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/providers/order_provider.dart';
import 'package:spinovo_app/screen/booking/booking_details_screen.dart';
import 'package:spinovo_app/screen/home/home_screen.dart';
import 'package:spinovo_app/services/bottom_navigation.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';
// import 'package:spinovo_app/screens/booking_details_screen.dart'; // Import the details screen

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch orders when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Current date and time for comparison (May 24, 2025, 11:29 PM IST)
    final currentDateTime = DateTime(2025, 5, 24, 23, 29);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        print("Back button pressed in BookingScreen");
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => const BottomNavigation(
                    indexSet: 0,
                  )),
        );
        return false; // prevent default back behavior
      },
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(
            title: "Your bookings",
            isBack: false,
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            if (orderProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (orderProvider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(orderProvider.errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        orderProvider.fetchOrders(); // Retry fetching orders
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (orderProvider.orders.isEmpty) {
              return const Center(child: Text('No bookings found'));
            }

            // Sort orders by date, showing upcoming first
            final sortedOrders = orderProvider.orders
              ..sort((a, b) {
                DateTime dateA;
                DateTime dateB;
                try {
                  dateA = DateTime.parse(a.createdAt!);
                  dateB = DateTime.parse(b.createdAt!);
                } catch (e) {
                  dateA = DateTime.now();
                  dateB = DateTime.now();
                }
                return dateB.compareTo(dateA); // Newest to oldest
              });

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: sortedOrders.length,
              itemBuilder: (context, index) {
                final order = sortedOrders[index];
                // Parse booking date and time
                DateTime bookingDate;
                bool isPastBooking = false;
                try {
                  bookingDate = DateTime.parse(order.createdAt!);
                  isPastBooking = bookingDate.isBefore(currentDateTime);
                } catch (e) {
                  bookingDate = DateTime.now(); // Fallback to current date
                }
                final formattedDate =
                    DateFormat('EEEE, d MMMM yyyy').format(bookingDate);
                final formattedTime = DateFormat('h:mm a').format(bookingDate);
                final formattedDay =
                    DateFormat('d').format(bookingDate).toUpperCase();
                final formattedMonth =
                    DateFormat('MMM').format(bookingDate).toUpperCase();

                return GestureDetector(
                  onTap: () {
                    // Navigate to BookingDetailsScreen on tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingDetailsScreen(order: order),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Date on the left
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SmallText(
                                  text: order.orderDisplayNo!,
                                  fontweights: FontWeight.bold,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                SmallText(
                                  text: "$formattedDay$formattedMonth",
                                  color: Colors.grey,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Booking details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                  text: formattedDate,
                                  fontweights: FontWeight.bold,
                                  overFlow: TextOverflow.visible,
                                  size: 16,
                                  color: isPastBooking
                                      ? Colors.grey.shade600
                                      : Colors.black,
                                ),
                                const Height(4),
                                SmallText(
                                  text:
                                      '${order.bookingDate} • ${order.bookingTime}',
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ),
                          // Status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: order.ordStatus == 'Pending'
                                  ? Colors.orange.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order.ordStatus!.toUpperCase(),
                              style: TextStyle(
                                color: order.ordStatus == 'Pending'
                                    ? Colors.orange
                                    : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
