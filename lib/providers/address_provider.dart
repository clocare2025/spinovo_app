import 'package:flutter/material.dart';
import 'package:spinovo_app/api/address_api.dart';
import 'package:spinovo_app/models/address_model.dart';

class AddressProvider with ChangeNotifier {
  final AddressApi _addressApi = AddressApi();
  bool _isLoading = false;
  String? _errorMessage;
  List<AddressData> _addresses = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<AddressData> get addresses => _addresses;

  // Create a new address
  Future<void> createAddress(Map<String, dynamic> addressData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _addressApi.createAddress(addressData);
      if (response.status == true && response.data != null) {
        _addresses.add(response.data!);
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

  // Fetch list of addresses
  Future<void> fetchAddresses() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final addresses = await _addressApi.getAddressList();
      _addresses = addresses;
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete an address
  Future<void> deleteAddress(String addressId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _addressApi.deleteAddress(addressId);
      _addresses.removeWhere((address) => address.addressId == addressId);
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set primary address
  void setPrimaryAddress(String addressId) {
    _addresses = _addresses.map((address) {
      address.isPrimary = address.addressId == addressId;
      return address;
    }).toList();
    notifyListeners();
  }
}




// import 'package:flutter/material.dart';
// import 'package:spinovo_app/api/address_api.dart';
// import 'package:spinovo_app/models/address_model.dart';

// class AddressProvider with ChangeNotifier {
//   final AddressApi _addressApi = AddressApi();
//   bool _isLoading = false;
//   String? _errorMessage;
//   AddressModel? _address;

//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   AddressModel? get address => _address;

//   Future<void> createAddress(Map<String, dynamic> addressData) async {
//     try {
//       _isLoading = true;
//       _errorMessage = null;
//       notifyListeners();

//       final response = await _addressApi.createAddress(addressData);
//       if (response.status == true) {
//         _address = response;
//       } else {
//         _errorMessage = response.msg ?? 'Failed to create address';
//       }
//     } catch (e) {
//       _errorMessage = 'Error: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }
