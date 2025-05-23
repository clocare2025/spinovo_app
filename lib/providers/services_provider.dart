import 'package:flutter/material.dart';
import 'package:spinovo_app/api/services_api.dart';
import 'package:spinovo_app/models/services_model.dart';

class ServicesProvider with ChangeNotifier {
  final ServicesApi _servicesApi = ServicesApi();
  bool _isLoading = false;
  String? _errorMessage;
  ServicesModel? _servicesList;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ServicesModel? get servicesList => _servicesList;

  Future<void> getServices() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _servicesApi.serviceList();
      if (response.status == true) {
        _servicesList = response;
      } else {
        _errorMessage = response.msg ?? 'Failed to fetch services';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}