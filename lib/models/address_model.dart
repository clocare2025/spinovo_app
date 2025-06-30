class AddressModel {
  bool? status;
  String? msg;
  AddressData? data;

  AddressModel({this.status, this.msg, this.data});

  AddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null && json['data']['address'] != null
        ? AddressData.fromJson(json['data']['address'])
        : null;
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
  String? building;
  String? street;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  String? formatAddress;
  bool? isPrimary;
  String? petsAtHome;
  String? latitude;
  String? longitude;



  AddressData({
    this.addressId,
    this.userId,
    this.addressType,
    this.addressLabel,
    this.flatNo,
    this.building,
    this.street,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.formatAddress,
    this.isPrimary,
    this.petsAtHome,
    this.latitude,  
    this.longitude,
  });

  AddressData.fromJson(Map<String, dynamic> json) {
    addressId = json['_id'];
    userId = json['customer_id'];
    addressType = json['address_type'];
    addressLabel = json['address_label'];
    flatNo = json['flat_no'];
    building = json['building'];
    street = json['street'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    formatAddress = json['format_address'];
    isPrimary = json['isPrimary'];
    petsAtHome = json['petsAtHome'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = addressId;
    data['customer_id'] = userId;
    data['address_type'] = addressType;
    data['address_label'] = addressLabel;
    data['flat_no'] = flatNo;
    data['building'] = building;
    data['street'] = street;
    data['landmark'] = landmark;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['format_address'] = formatAddress;
    data['isPrimary'] = isPrimary;
    data['petsAtHome'] = petsAtHome;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}