import 'package:flutter/material.dart';
import 'package:spinovo_app/api/address_api.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/services/share_preferences.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = false;
  final AddressApiService _apiService = AddressApiService();
  final SharedPreferencesService _storageService = SharedPreferencesService();

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;

  Future<void> createAddress(Map<String, dynamic> addressData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await _storageService.read('access_token');
      if (token == null) {
        throw Exception('No access token found');
      }
      final address = await _apiService.createAddress(addressData, token);
      _addresses.add(address);
    } catch (e) {
      throw Exception('Failed to create address: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAddresses() async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await _storageService.read('access_token');
      if (token == null) {
        throw Exception('No access token found');
      }
      _addresses = await _apiService.getAddressList(token);
    } catch (e) {
      throw Exception('Failed to fetch addresses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String addressId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await _storageService.read('access_token');
      if (token == null) {
        throw Exception('No access token found');
      }
      await _apiService.deleteAddress(addressId, token);
      _addresses.removeWhere((address) => address.id == addressId);
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
