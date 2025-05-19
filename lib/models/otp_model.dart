class OtpModel {
  bool? status;
  String? msg;
  Data? data;

  OtpModel({this.status, this.msg, this.data});

  OtpModel.fromJson(Map<String, dynamic> json) {
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
  OtpResponse? otpResponse;

  Data({this.otpResponse});

  Data.fromJson(Map<String, dynamic> json) {
    otpResponse = json['otpResponse'] != null
        ? new OtpResponse.fromJson(json['otpResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.otpResponse != null) {
      data['otpResponse'] = this.otpResponse!.toJson();
    }
    return data;
  }
}

class OtpResponse {
  String? mobileNo;
  String? otpCode;
  String? otpRequest;
  String? otpSendResponse;
  String? sId;
  String? createdAt;
  String? updatedAt;

  OtpResponse(
      {this.mobileNo,
      this.otpCode,
      this.otpRequest,
      this.otpSendResponse,
      this.sId,
      this.createdAt,
      this.updatedAt});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    mobileNo = json['mobile_no'];
    otpCode = json['otp_code'];
    otpRequest = json['otp_request'];
    otpSendResponse = json['otp_send_response'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile_no'] = this.mobileNo;
    data['otp_code'] = this.otpCode;
    data['otp_request'] = this.otpRequest;
    data['otp_send_response'] = this.otpSendResponse;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}