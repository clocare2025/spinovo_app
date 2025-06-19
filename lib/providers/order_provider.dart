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

  Future<void> fetchOrders() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _ordersList = await _orderApi.getList();
    } catch (e) {
      _errorMessage = 'Error fetching orders: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBooking(Map<String, dynamic> bookingDetails) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _orderApi.booking(bookingDetails);
      await fetchOrders(); // Refresh order list
    } catch (e) {
      _errorMessage = 'Error creating booking: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
