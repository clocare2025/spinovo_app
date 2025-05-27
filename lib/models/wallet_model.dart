class WalletModel {
  bool? status;
  String? msg;
  Data? data;

  WalletModel({this.status, this.msg, this.data});

  WalletModel.fromJson(Map<String, dynamic> json) {
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
  Wallet? wallet;
  List<History>? history;

  Data({this.wallet, this.history});

  Data.fromJson(Map<String, dynamic> json) {
    wallet =
        json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(new History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    if (this.history != null) {
      data['history'] = this.history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wallet {
  int? cash;
  int? bonus;
  int? totalBalance;

  Wallet({this.cash, this.bonus, this.totalBalance});

  Wallet.fromJson(Map<String, dynamic> json) {
    cash = json['cash'];
    bonus = json['bonus'];
    totalBalance = json['total_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cash'] = this.cash;
    data['bonus'] = this.bonus;
    data['total_balance'] = this.totalBalance;
    return data;
  }
}

class History {
  String? sId;
  String? customerId;
  String? transactionId;
  String? walletType;
  int? amount;
  String? transactionType;
  String? gatewayResponse;
  String? reason;
  String? message;
  int? status;
  String? createdAt;
  String? updatedAt;

  History(
      {this.sId,
      this.customerId,
      this.transactionId,
      this.walletType,
      this.amount,
      this.transactionType,
      this.gatewayResponse,
      this.reason,
      this.message,
      this.status,
      this.createdAt,
      this.updatedAt});

  History.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customerId = json['customer_id'];
    transactionId = json['transaction_id'];
    walletType = json['wallet_type'];
    amount = json['amount'];
    transactionType = json['transaction_type'];
    gatewayResponse = json['gateway_response'];
    reason = json['reason'];
    message = json['message'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['customer_id'] = this.customerId;
    data['transaction_id'] = this.transactionId;
    data['wallet_type'] = this.walletType;
    data['amount'] = this.amount;
    data['transaction_type'] = this.transactionType;
    data['gateway_response'] = this.gatewayResponse;
    data['reason'] = this.reason;
    data['message'] = this.message;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}