import 'package:flutter/material.dart';
import 'package:spinovo_app/api/order_api.dart';
import 'package:spinovo_app/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final OrderApi _orderApi = OrderApi();
  bool _isLoading = false;
  String? _errorMessage;
  List<Order> _ordersList = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Order> get orders => _ordersList;

  // Fetch list of orders
  Future<void> fetchOrders() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final orderss = await _orderApi.getList();
      _ordersList = orderss;
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}
