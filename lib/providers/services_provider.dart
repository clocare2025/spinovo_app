import 'package:flutter/material.dart';
import 'package:spinovo_app/api/services_api.dart';
import 'package:spinovo_app/models/services_model.dart';

class ServicesProvider with ChangeNotifier {
  final ServicesApi _servicesApi = ServicesApi();
  bool _isLoading = false;
  String? _errorMessage;
  ServicesModel? _servicesList;
  List<Map<String, dynamic>> _selectedServiceCategories = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ServicesModel? get servicesList => _servicesList;
  List<Map<String, dynamic>> get selectedServiceCategories =>
      _selectedServiceCategories;

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

  void addServiceCategory(
      int serviceId, int categoryId, String price, int items) {
    // Find if service_id already exists
    var serviceEntry = _selectedServiceCategories.firstWhere(
      (entry) => entry['service_id'] == serviceId,
      orElse: () => {'service_id': serviceId, 'categorys': []},
    );

    // If service entry doesn't exist, add it to the list
    if (!_selectedServiceCategories.contains(serviceEntry)) {
      _selectedServiceCategories.add(serviceEntry);
    }

    // Find category within the service
    List categorys = serviceEntry['categorys'];
    var categoryEntry = categorys.firstWhere(
      (cat) => cat['category_id'] == categoryId,
      orElse: () =>
          {'category_id': categoryId, 'category_prices': price, 'items': 0},
    );

    // Update items
    categoryEntry['items'] = items;

    // If category doesn't exist in service, add it
    if (!categorys.contains(categoryEntry)) {
      categorys.add(categoryEntry);
    }

    notifyListeners();
  }

  void removeServiceCategory(int serviceId, int categoryId) {
    var serviceEntry = _selectedServiceCategories.firstWhere(
      (entry) => entry['service_id'] == serviceId,
      orElse: () => {},
    );

    if (serviceEntry.isNotEmpty) {
      List categorys = serviceEntry['categorys'];
      categorys.removeWhere((cat) => cat['category_id'] == categoryId);
      if (categorys.isEmpty) {
        _selectedServiceCategories.remove(serviceEntry);
      }
    }

    notifyListeners();
  }

  int getItemsForCategory(int serviceId, int categoryId) {
    var serviceEntry = _selectedServiceCategories.firstWhere(
      (entry) => entry['service_id'] == serviceId,
      orElse: () => {},
    );

    if (serviceEntry.isNotEmpty) {
      var categoryEntry = serviceEntry['categorys'].firstWhere(
        (cat) => cat['category_id'] == categoryId,
        orElse: () => {},
      );
      return categoryEntry.isNotEmpty ? categoryEntry['items'] : 0;
    }
    return 0;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
