import 'package:flutter/material.dart';
import 'package:spinovo_app/api/paymentMode_api.dart';

class PaymentModeProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _availablePaymentModes = [];
  String? _selectedPaymentMode;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get availablePaymentModes => _availablePaymentModes;
  String? get selectedPaymentMode => _selectedPaymentMode;

  PaymentModeProvider() {
    fetchPaymentModes();
  }

  Future<void> fetchPaymentModes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final paymentModeApi = PaymentModeApi();
      final paymentModeModel = await paymentModeApi.fetchPaymentModes();
      if (paymentModeModel.status == true && paymentModeModel.data != null) {
        _availablePaymentModes = paymentModeModel.data!.paymentModes!
            .where((mode) => mode.isActive == true)
            .map((mode) => mode.paymentMode!)
            .toList();
        _selectedPaymentMode = _availablePaymentModes.isNotEmpty ? _availablePaymentModes.first : null;
      } else {
        _errorMessage = paymentModeModel.msg ?? 'Failed to fetch payment modes';
      }
    } catch (e) {
      _errorMessage = 'Error fetching payment modes: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedPaymentMode(String? mode) {
    if (mode != null && _availablePaymentModes.contains(mode)) {
      _selectedPaymentMode = mode;
      notifyListeners();
    }
  }
}