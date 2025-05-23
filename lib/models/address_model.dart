class AddressModel {
  bool? status;
  String? msg;
  AddressData? data;

  AddressModel({this.status, this.msg, this.data});

  AddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? AddressData.fromJson(json['data']) : null;
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

class AddressData {
  String? addressId;
  String? userId;
  String? addressType;
  String? addressLabel;
  String? flatNo;
  String? street;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  String? formatAddress;
  bool? isPrimary;

  AddressData({
    this.addressId,
    this.userId,
    this.addressType,
    this.addressLabel,
    this.flatNo,
    this.street,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.formatAddress,
    this.isPrimary,
  });

  AddressData.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    userId = json['userId'];
    addressType = json['address_type'];
    addressLabel = json['address_label'];
    flatNo = json['flat_no'];
    street = json['street'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    formatAddress = json['format_address'];
    isPrimary = json['isPrimary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addressId'] = addressId;
    data['userId'] = userId;
    data['address_type'] = addressType;
    data['address_label'] = addressLabel;
    data['flat_no'] = flatNo;
    data['street'] = street;
    data['landmark'] = landmark;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['format_address'] = formatAddress;
    data['isPrimary'] = isPrimary;
    return data;
  }
}
