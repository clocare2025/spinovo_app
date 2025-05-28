import 'dart:convert';

class PackageModel {
  final bool status;
  final String msg;
  final PackageData data;

  PackageModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      data: PackageData.fromJson(json['data'] ?? {}),
    );
  }
}

class PackageData {
  final List<Package> packages;

  PackageData({required this.packages});

  factory PackageData.fromJson(Map<String, dynamic> json) {
    var packageList = json['package'] as List<dynamic>? ?? [];
    return PackageData(
      packages: packageList
          .map((package) => Package.fromJson(package))
          .toList(),
    );
  }
}

class Package {
  final int packageId;
  final int originalPrices;
  final int discountPrices;
  final int discount;
  final int noOfClothes;
  final List<Service> services;

  Package({
    required this.packageId,
    required this.originalPrices,
    required this.discountPrices,
    required this.discount,
    required this.noOfClothes,
    required this.services,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    var serviceList = json['services'] as List<dynamic>? ?? [];
    return Package(
      packageId: json['package_id'] ?? 0,
      originalPrices: json['orignal_prices'] ?? 0,
      discountPrices: json['discount_prices'] ?? 0,
      discount: json['discount'] ?? 0,
      noOfClothes: json['no_of_clothes'] ?? 0,
      services: serviceList
          .map((service) => Service.fromJson(service))
          .toList(),
    );
  }
}

class Service {
  final String serviceName;
  final int clothes;
  final int originalPrice;
  final int discountPrice;

  Service({
    required this.serviceName,
    required this.clothes,
    required this.originalPrice,
    required this.discountPrice,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceName: json['services_name'] ?? '',
      clothes: json['clothes'] ?? 0,
      originalPrice: json['orignal_prices'] ?? 0,
      discountPrice: json['discount_prices'] ?? 0,
    );
  }
}