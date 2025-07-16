class OrderPlaceDetailsModel {
  // Step 1: Service Details
  String? orderType;
  String? serviceName;
  int? orderQty;
  int? deliveryCharge;
  int? orderAmount;
  String? orderDetails;
  String? addressId;
  // Step 2: Slot Details
  int? slotCharges;
  String? bookingDate;
  String? bookingTime;
  // Step 3: Payment Details
  int? handlingCharges;
  int? serviceCharges;
  int? tipAmount;
  int? totalBilling;
  String? paymentMode;
  String? paymentStatus;

  OrderPlaceDetailsModel({
    this.orderType,
    this.serviceName,
    this.orderQty,
    this.deliveryCharge,
    this.orderAmount,
    this.orderDetails,
    this.addressId,
    this.slotCharges,
    this.bookingDate,
    this.bookingTime,
    this.handlingCharges,
    this.serviceCharges,
    this.tipAmount,
    this.totalBilling,
    this.paymentMode,
    this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_type': orderType,
      'service_name': serviceName,
      'order_qty': orderQty,
      'delivery_charge': deliveryCharge,
      'order_amount': orderAmount,
      'order_details': orderDetails,
      'address_id': addressId,
      'slot_charges': slotCharges,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'handling_charges': handlingCharges,
      'service_charges': serviceCharges,
      'tip_amount': tipAmount,
      'total_billing': totalBilling,
      'payment_mode': paymentMode,
      'payment_status': paymentStatus,
    };
  }
}
