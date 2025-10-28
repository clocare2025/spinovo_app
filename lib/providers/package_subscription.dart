// lib/providers/package_subscription.dart  (already registered in main.dart)

import 'package:flutter/material.dart';
import 'package:spinovo_app/api/package_subscription.dart';
import 'package:spinovo_app/models/subscription_model.dart';

class PackageSubscripionProvider with ChangeNotifier {
  final PackageSubscriptionApi _api = PackageSubscriptionApi();

  bool _loading = false;
  String? _error;
  SubscriptionModel? _model;

  bool get isLoading => _loading;
  String? get errorMessage => _error;
  SubscriptionModel? get subscriptionModel => _model;

  // ----- GET -----
  Future<void> fetchSubscriptions() async {
    try {
      _loading = true; _error = null; notifyListeners();
      _model = await _api.getSubscriptionList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  // ----- BUY -----
  Future<Map<String, dynamic>> buyPackage(Map<String, dynamic> payload) async {
    try {
      _loading = true; _error = null; notifyListeners();
      final result = await _api.buyPackage(payload);
      return result;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false; notifyListeners();
    }
  }
}