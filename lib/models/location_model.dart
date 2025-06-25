class LocationModel {
  bool? status;
  String? msg;
  Data? data;

  LocationModel({this.status, this.msg, this.data});

  LocationModel.fromJson(Map<String, dynamic> json) {
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
  List<String>? state;
  List<String>? cities;
  List<String>? pincode;

  Data({this.state, this.cities, this.pincode});

  Data.fromJson(Map<String, dynamic> json) {
    state = json['state'].cast<String>();
    cities = json['cities'].cast<String>();
    pincode = json['pincode'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['cities'] = this.cities;
    data['pincode'] = this.pincode;
    return data;
  }
}
