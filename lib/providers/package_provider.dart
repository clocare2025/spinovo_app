import 'package:flutter/material.dart';
import 'package:spinovo_app/api/package_api.dart';
import 'package:spinovo_app/models/package_model.dart';

class PackageProvider with ChangeNotifier {
  final PackageApi _packageApi = PackageApi();
  bool _isLoading = false;
  String? _errorMessage;
  PackageModel? _packageModel;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PackageModel? get packageModel => _packageModel;

  Future<void> fetchPackages() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _packageApi.fetchPackages();
      if (response.status == true) {
        _packageModel = response;
      } else {
        _errorMessage = response.msg ?? 'Failed to fetch packages';
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