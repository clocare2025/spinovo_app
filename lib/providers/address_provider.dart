import 'package:flutter/material.dart';
import 'package:spinovo_app/api/address_api.dart';
import 'package:spinovo_app/models/address_model.dart';

class AddressProvider with ChangeNotifier {
  final AddressApi _addressApi = AddressApi();
  bool _isLoading = false;
  String? _errorMessage;
  AddressModel? _address;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AddressModel? get address => _address;

  Future<void> createAddress(Map<String, dynamic> addressData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _addressApi.createAddress(addressData);
      if (response.status == true) {
        _address = response;
      } else {
        _errorMessage = response.msg ?? 'Failed to create address';
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
