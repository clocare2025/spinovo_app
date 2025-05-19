class UserModel {
  bool? status;
  String? msg;
  Data? data;

  UserModel({this.status, this.msg, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  User? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? mobile;
  String? email;
  int? walletBalance;
  int? spinovoBonus;
  int? famillyMember;
  String? livingType;
  String? gender;
  String? dob;
  String? profilePic;
  String? accessToken;
  String? fcmToken;
  int? cityId;
  bool? isActive;
  int? soures;
  String? sId;
  String? lastActive;
  String? createdAt;
  String? updatedAt;

  User(
      {this.name,
      this.mobile,
      this.email,
      this.walletBalance,
      this.spinovoBonus,
      this.famillyMember,
      this.livingType,
      this.gender,
      this.dob,
      this.profilePic,
      this.accessToken,
      this.fcmToken,
      this.cityId,
      this.isActive,
      this.soures,
      this.sId,
      this.lastActive,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    walletBalance = json['wallet_balance'];
    spinovoBonus = json['spinovo_bonus'];
    famillyMember = json['familly_member'];
    livingType = json['living_type'];
    gender = json['gender'];
    dob = json['dob'];
    profilePic = json['profile_pic'];
    accessToken = json['access_token'];
    fcmToken = json['fcmToken'];
    cityId = json['city_id'];
    isActive = json['isActive'];
    soures = json['soures'];
    sId = json['_id'];
    lastActive = json['lastActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['wallet_balance'] = this.walletBalance;
    data['spinovo_bonus'] = this.spinovoBonus;
    data['familly_member'] = this.famillyMember;
    data['living_type'] = this.livingType;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['profile_pic'] = this.profilePic;
    data['access_token'] = this.accessToken;
    data['fcmToken'] = this.fcmToken;
    data['city_id'] = this.cityId;
    data['isActive'] = this.isActive;
    data['soures'] = this.soures;
    data['_id'] = this.sId;
    data['lastActive'] = this.lastActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}