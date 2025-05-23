class ServicesModel {
  bool? status;
  String? msg;
  Data? data;

  ServicesModel({this.status, this.msg, this.data});

  ServicesModel.fromJson(Map<String, dynamic> json) {
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
  List<Service>? service;

  Data({this.service});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['service'] != null) {
      service = <Service>[];
      json['service'].forEach((v) {
        service!.add(new Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.service != null) {
      data['service'] = this.service!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  int? serviceId;
  String? service;
  int? original;
  int? discounted;
  List<PricesByQty>? pricesByQty;

  Service(
      {this.serviceId,
      this.service,
      this.original,
      this.discounted,
      this.pricesByQty});

  Service.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    service = json['service'];
    original = json['original'];
    discounted = json['discounted'];
    if (json['prices_by_qty'] != null) {
      pricesByQty = <PricesByQty>[];
      json['prices_by_qty'].forEach((v) {
        pricesByQty!.add(new PricesByQty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service'] = this.service;
    data['original'] = this.original;
    data['discounted'] = this.discounted;
    if (this.pricesByQty != null) {
      data['prices_by_qty'] = this.pricesByQty!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PricesByQty {
  int? qty;

  PricesByQty({this.qty});

  PricesByQty.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qty'] = this.qty;
    return data;
  }
}