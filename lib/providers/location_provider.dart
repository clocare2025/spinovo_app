import 'package:flutter/material.dart';
import 'package:spinovo_app/api/location_api.dart';
import 'package:spinovo_app/models/location_model.dart';

class LocationProvider with ChangeNotifier {
  final LocationApi _locationApi = LocationApi();
  LocationModel? _locationModel;
  bool _isLoading = false;
  String? _errorMessage;

  LocationModel? get locationModel => _locationModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getLocationList() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _locationApi.getLocation();
      if (response.status == true) {
        _locationModel = response;
      } else {
        _errorMessage = response.msg ?? 'Failed to fetch location list';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
