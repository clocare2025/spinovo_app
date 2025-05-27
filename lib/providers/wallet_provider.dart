import 'package:flutter/material.dart';
import 'package:spinovo_app/api/wallet_api.dart';
import 'package:spinovo_app/models/wallet_model.dart';

class WalletProvider with ChangeNotifier {
  final WalletApi _walletApi = WalletApi();
  bool _isLoading = false;
  String? _errorMessage;
  WalletModel? _walletBalance;
  WalletModel? _transactionHistory;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  WalletModel? get walletBalance => _walletBalance;
  WalletModel? get transactionHistory => _transactionHistory;

  Future<void> credit({
    required int amount,
    required String transactionId,
    required String gatewayResponse,
    String reason = "wallet recharge",
    String message = "deposit",
    int status = 1,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final walletData = {
        'amount': amount,
        'transaction_id': transactionId,
        'gateway_response': gatewayResponse,
        'reason': reason,
        'message': message,
        'status': status,
      };

      final response = await _walletApi.credit(walletData);
      await fetchBalance(); // Refresh balance after credit
      await fetchTransactionHistory(); // Refresh history after credit
    } catch (e) {
      _errorMessage = 'Error crediting wallet: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> debit({
    required int amount,
    required String transactionId,
    required String gatewayResponse,
    String reason = "booking",
    String message = "services booking",
    int status = 1,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final walletData = {
        'amount': amount,
        'transaction_id': transactionId,
        'gateway_response': gatewayResponse,
        'reason': reason,
        'message': message,
        'status': status,
      };

      final response = await _walletApi.debit(walletData);
      await fetchBalance(); // Refresh balance after debit
      await fetchTransactionHistory(); // Refresh history after debit
    } catch (e) {
      _errorMessage = 'Error debiting wallet: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBalance() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _walletBalance = await _walletApi.getBalance();
    } catch (e) {
      _errorMessage = 'Error fetching wallet balance: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTransactionHistory() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _transactionHistory = await _walletApi.getTransactionHistory();
    } catch (e) {
      _errorMessage = 'Error fetching transaction history: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}