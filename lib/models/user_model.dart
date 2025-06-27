class UserModel {
  bool? status;
  String? msg;
  Data? data;

  UserModel({this.status, this.msg, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  Profile? profile;

  Data({this.profile});

  Data.fromJson(Map<String, dynamic> json) {
    profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null; // Changed 'user' to 'profile'
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson(); // Changed 'user' to 'profile'
    }
    return data;
  }
}

class Profile {
  String? name;
  String? mobile;
  String? alternateNumber;
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
  bool? isDeleted;

  Profile({
    this.name,
    this.mobile,
    this.alternateNumber,
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
    this.isDeleted,
    this.soures,
    this.sId,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    alternateNumber = json['alternateNumber'];
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
    isDeleted = json['isDeleted'];
    soures = json['sources'];
    sId = json['_id'];
    lastActive = json['lastActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updated_at']; // Changed 'updatedAt' to 'updated_at'
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobile'] = mobile;
    data['alternateNumber'] = alternateNumber;
    data['email'] = email;
    data['wallet_balance'] = walletBalance;
    data['spinovo_bonus'] = spinovoBonus;
    data['familly_member'] = famillyMember;
    data['living_type'] = livingType;
    data['gender'] = gender;
    data['dob'] = dob;
    data['profile_pic'] = profilePic;
    data['access_token'] = accessToken;
    data['fcmToken'] = fcmToken;
    data['city_id'] = cityId;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['soures'] = soures;
    data['_id'] = sId;
    data['lastActive'] = lastActive;
    data['createdAt'] = createdAt;
    data['updated_at'] = updatedAt; // Changed 'updatedAt' to 'updated_at'
    return data;
  }
}