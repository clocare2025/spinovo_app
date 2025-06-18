class OrderModel {
  bool? status;
  String? msg;
  Data? data;

  OrderModel({this.status, this.msg, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Order? order;

  Data({this.order});

  Data.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  String? customerId;
  int? orderNo;
  String? orderDisplayNo;
  int? orderStageId;
  String? orderType;
  int? serviceId;
  String? serviceName;
  int? garmentQty;
  int? garmentOriginalAmount;
  int? garmentDiscountAmount;
  int? serviceCharges;
  int? slotCharges;
  int? handlingCharges;
  int? tipAmount;
  int? orderAmount;
  int? totalBilling;
  String? paymentMode;
  String? paymentStatus;
  String? transactionId;
  String? bookingDate;
  String? bookingTime;
  String? addressId;
  String? ordStatus;
  String? sId;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.customerId,
      this.orderNo,
      this.orderDisplayNo,
      this.orderStageId,
      this.orderType,
      this.serviceId,
      this.serviceName,
      this.garmentQty,
      this.garmentOriginalAmount,
      this.garmentDiscountAmount,
      this.serviceCharges,
      this.slotCharges,
      this.handlingCharges,
      this.tipAmount,
      this.orderAmount,
      this.totalBilling,
      this.paymentMode,
      this.paymentStatus,
      this.transactionId,
      this.bookingDate,
      this.bookingTime,
      this.addressId,
      this.ordStatus,
      this.sId,
      this.createdAt,
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    orderNo = json['order_no'];
    orderDisplayNo = json['order_display_no'];
    orderStageId = json['order_stage_id'];
    orderType = json['order_type'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    garmentQty = json['garment_qty'];
    garmentOriginalAmount = json['garment_original_amount'];
    garmentDiscountAmount = json['garment_discount_amount'];
    serviceCharges = json['service_charges'];
    slotCharges = json['slot_charges'];
    handlingCharges = json['handling_charges'];
    tipAmount = json['tip_amount'];
    orderAmount = json['order_amount'];
    totalBilling = json['total_billing'];
    paymentMode = json['payment_mode'];
    paymentStatus = json['payment_status'];
    transactionId = json['transaction_id'];
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    addressId = json['address_id'];
    ordStatus = json['ord_status'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['order_no'] = this.orderNo;
    data['order_display_no'] = this.orderDisplayNo;
    data['order_stage_id'] = this.orderStageId;
    data['order_type'] = this.orderType;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['garment_qty'] = this.garmentQty;
    data['garment_original_amount'] = this.garmentOriginalAmount;
    data['garment_discount_amount'] = this.garmentDiscountAmount;
    data['service_charges'] = this.serviceCharges;
    data['slot_charges'] = this.slotCharges;
    data['handling_charges'] = this.handlingCharges;
    data['tip_amount'] = this.tipAmount;
    data['order_amount'] = this.orderAmount;
    data['total_billing'] = this.totalBilling;
    data['payment_mode'] = this.paymentMode;
    data['payment_status'] = this.paymentStatus;
    data['transaction_id'] = this.transactionId;
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    data['address_id'] = this.addressId;
    data['ord_status'] = this.ordStatus;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
