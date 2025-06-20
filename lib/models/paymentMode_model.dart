class PaymentModeModel {
  bool? status;
  String? msg;
  PaymentModeData? data;

  PaymentModeModel({this.status, this.msg, this.data});

  PaymentModeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? PaymentModeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PaymentModeData {
  int? codOrderCount;
  List<PaymentModeOption>? paymentModes;

  PaymentModeData({this.codOrderCount, this.paymentModes});

  PaymentModeData.fromJson(Map<String, dynamic> json) {
    codOrderCount = json['cod_order_count'];
    if (json['payment_modes'] != null) {
      paymentModes = <PaymentModeOption>[];
      json['payment_modes'].forEach((v) {
        paymentModes!.add(PaymentModeOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cod_order_count'] = this.codOrderCount;
    if (this.paymentModes != null) {
      data['payment_modes'] = this.paymentModes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentModeOption {
  String? paymentMode;
  bool? isActive;

  PaymentModeOption({this.paymentMode, this.isActive});

  PaymentModeOption.fromJson(Map<String, dynamic> json) {
    paymentMode = json['payment_mode'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_mode'] = this.paymentMode;
    data['isActive'] = this.isActive;
    return data;
  }
}