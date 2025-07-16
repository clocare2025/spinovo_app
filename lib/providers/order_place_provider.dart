import 'package:flutter/material.dart';
import 'package:spinovo_app/models/order_place_model.dart';

class OrderPlaceDetailsProvider extends ChangeNotifier {
  OrderPlaceDetailsModel _booking = OrderPlaceDetailsModel();

  OrderPlaceDetailsModel get booking => _booking;

  // STEP 1: Service Info
  void updateService({
    required String orderType,
    required String serviceName,
    required int orderQty,
    required int deliveryCharge,
    required int orderAmount,
    required String orderDetails,
    required String addressId,
  }) {
    _booking.orderType = orderType;
    _booking.serviceName = serviceName;
    _booking.orderQty = orderQty;
    _booking.deliveryCharge = deliveryCharge;
    _booking.orderAmount = orderAmount;
    _booking.orderDetails = orderDetails;
    _booking.addressId = addressId;
    notifyListeners();
  }

  // STEP 2: Slot Info
  void updateSlot({
    required int slotCharges,
    required String bookingDate,
    required String bookingTime,
  }) {
    _booking.slotCharges = slotCharges;
    _booking.bookingDate = bookingDate;
    _booking.bookingTime = bookingTime;
    notifyListeners();
  }

  // STEP 3: Payment Info
  void updatePayment({
    required int handlingCharges,
    required int serviceCharges,
    required int tipAmount,
    required int totalBilling,
    required String paymentMode,
    required String paymentStatus,
  }) {
    _booking.handlingCharges = handlingCharges;
    _booking.serviceCharges = serviceCharges;
    _booking.tipAmount = tipAmount;
    _booking.totalBilling = totalBilling;
    _booking.paymentMode = paymentMode;
    _booking.paymentStatus = paymentStatus;
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return _booking.toMap();
  }

  void resetBooking() {
    _booking = OrderPlaceDetailsModel(); // Clear all fields
    notifyListeners();
  }
}
