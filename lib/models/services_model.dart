import 'dart:convert';

class ServicesModel {
  bool? status;
  String? msg;
  Data? data;

  ServicesModel({this.status, this.msg, this.data});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? deliveryCharge;
  int? mov;
  List<Service>? service;

  Data({this.service, this.deliveryCharge, this.mov});

  Data.fromJson(Map<String, dynamic> json) {
    deliveryCharge = json['delivery_charge'];
    mov = json['mov'];
    if (json['service'] != null) {
      service = <Service>[];
      json['service'].forEach((v) {
        service!.add(Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delivery_charge'] = deliveryCharge;
    data['mov'] = mov;

    if (service != null) {
      data['service'] = service!.map((v) => v.toJson()).toList();
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
  List<Category>? categoryList;

  Service({
    this.serviceId,
    this.service,
    this.label,
    this.minQty,
    this.original,
    this.discounted,
    this.duration,
    this.description,
    this.pricesByQty,
    this.categoryList,
  });

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
    if (json['category_list'] != null) {
      categoryList = <Category>[];
      json['category_list'].forEach((v) {
        categoryList!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service'] = service;
    data['label'] = label;
    data['min_qtq'] = minQty;
    data['original'] = original;
    data['discounted'] = discounted;
    data['duration'] = duration;
    data['description'] = description;
    if (pricesByQty != null) {
      data['prices_by_qty'] = pricesByQty!.map((v) => v.toJson()).toList();
    }
    if (categoryList != null) {
      data['category_list'] = categoryList!.map((v) => v.toJson()).toList();
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

class Category {
  int? categoryId;
  String? category;
  String? description;
  String? price;
  List<String>? typesOfClothes;

  Category({
    this.categoryId,
    this.category,
    this.description,
    this.price,
    this.typesOfClothes,
  });

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    category = json['category'];
    description = json['description'];
    price = json['price'];
    typesOfClothes = json['types_of_Clothes']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category'] = category;
    data['description'] = description;
    data['price'] = price;
    data['types_of_Clothes'] = typesOfClothes;
    return data;
  }
}
