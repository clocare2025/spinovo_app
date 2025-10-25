// Add this new file: lib/providers/package_provider.dart (it was already registered in main.dart, now implement it)

import 'package:flutter/material.dart';
import 'package:spinovo_app/api/package_api.dart';
import 'package:spinovo_app/api/package_subscription.dart';
import 'package:spinovo_app/models/subscription_model.dart';

class PackageSubscripionProvider with ChangeNotifier {
  final PackageSubscripionApi _packageApi = PackageSubscripionApi();
  bool _isLoading = false;
  String? _errorMessage;
  SubscriptionModel? _subscriptionModel;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  SubscriptionModel? get subscriptionModel => _subscriptionModel;

  Future<void> fetchSubscriptions() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _subscriptionModel = await _packageApi.getSubscriptionList();
    } catch (e) {
      _errorMessage = 'Error fetching subscriptions: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> buyPackage(Map<String, dynamic> packageDetails) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _packageApi.buyPackage(packageDetails);
      // Optionally refresh subscriptions or handle success
    } catch (e) {
      _errorMessage = 'Error buying package: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}