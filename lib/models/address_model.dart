class Address {
  final String id;
  final String customerId;
  final String addressType;
  final String addressLabel;
  final String flatNo;
  final String street;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String formattedAddress;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.customerId,
    required this.addressType,
    required this.addressLabel,
    required this.flatNo,
    required this.street,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.formattedAddress,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'],
      customerId: json['customer_id'],
      addressType: json['address_type'],
      addressLabel: json['address_label'],
      flatNo: json['flat_no'],
      street: json['street'],
      landmark: json['landmark'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      formattedAddress: json['format_address'],
      isPrimary: json['isPrimary'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
