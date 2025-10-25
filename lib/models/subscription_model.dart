// Add this new file: lib/models/subscription_model.dart

import 'dart:convert';

class SubscriptionModel {
  final bool status;
  final String msg;
  final SubscriptionData data;

  SubscriptionModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      data: SubscriptionData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data.toJson(),
    };
  }
}

class SubscriptionData {
  final List<Subscription> subscriptions;

  SubscriptionData({
    required this.subscriptions,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    var subscriptionList = json['Subscription'] as List? ?? [];
    return SubscriptionData(
      subscriptions: subscriptionList.map((sub) => Subscription.fromJson(sub)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Subscription': subscriptions.map((sub) => sub.toJson()).toList(),
    };
  }
}

class Subscription {
  final int id;
  final String name;
  final List<Plan> plans;

  Subscription({
    required this.id,
    required this.name,
    required this.plans,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    var planList = json['plan'] as List? ?? [];
    return Subscription(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      plans: planList.map((plan) => Plan.fromJson(plan)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'plan': plans.map((plan) => plan.toJson()).toList(),
    };
  }
}

class Plan {
  final int validity;
  final List<SubPlan> subPlans;

  Plan({
    required this.validity,
    required this.subPlans,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    var subPlanList = json['sub_plan'] as List? ?? [];
    return Plan(
      validity: json['validity'] ?? 0,
      subPlans: subPlanList.map((subPlan) => SubPlan.fromJson(subPlan)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'validity': validity,
      'sub_plan': subPlans.map((subPlan) => subPlan.toJson()).toList(),
    };
  }
}

class SubPlan {
  final int clothes;
  final int discountRate;
  final int prices;
  final int noOfPickups;

  SubPlan({
    required this.clothes,
    required this.discountRate,
    required this.prices,
    required this.noOfPickups,
  });

  factory SubPlan.fromJson(Map<String, dynamic> json) {
    return SubPlan(
      clothes: json['clothes'] ?? 0,
      discountRate: json['discount_rate'] ?? 0,
      prices: json['prices'] ?? 0,
      noOfPickups: json['no_of_pickups'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clothes': clothes,
      'discount_rate': discountRate,
      'prices': prices,
      'no_of_pickups': noOfPickups,
    };
  }
}