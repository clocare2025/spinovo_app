class ServicesModel {
  bool? status;
  String? msg;
  Data? data;

  ServicesModel({this.status, this.msg, this.data});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
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

class Data {
  List<Service>? service;

  Data({this.service});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['service'] != null) {
      service = <Service>[];
      json['service'].forEach((v) {
        service!.add( Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.service != null) {
      data['service'] = this.service!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  int? serviceId;
  String? service;
  String? label;
  int? minQty;
  int? original;
  int? discounted;
  String? duration;
  String? description;
  List<PricesByQty>? pricesByQty;

  Service(
      {this.serviceId,
      this.service,
      this.label,
      this.minQty,
      this.original,
      this.discounted,
      this.duration,
      this.description,
      this.pricesByQty});

  Service.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    service = json['service'];
    label = json['label'];
    minQty = json['min_qtq'];
    original = json['original'];
    discounted = json['discounted'];
    duration = json['duration'];
    description = json['description'];
    if (json['prices_by_qty'] != null) {
      pricesByQty = <PricesByQty>[];
      json['prices_by_qty'].forEach((v) {
        pricesByQty!.add(PricesByQty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service'] = service;
    data['original'] = this.original;
    data['discounted'] = this.discounted;
    data['label'] = label;
    data['min_qtq'] = this.minQty;
    data['duration'] = this.duration;
    data['description'] = this.description;
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
