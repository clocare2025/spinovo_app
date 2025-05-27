import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/wallet_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class WalletApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<WalletModel> credit(Map<String, dynamic> walletData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/consumer/wallet/credit'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(walletData),
    );

    if (response.statusCode == 200) {
      return WalletModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['msg'] ?? 'Failed to credit wallet: ${response.statusCode}');
    }
  }

  Future<WalletModel> debit(Map<String, dynamic> walletData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/consumer/wallet/debit'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(walletData),
    );

    if (response.statusCode == 200) {
      return WalletModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['msg'] ?? 'Failed to debit wallet: ${response.statusCode}');
    }
  }

  Future<WalletModel> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/consumer/wallet/balance'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return WalletModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['msg'] ?? 'Failed to fetch wallet balance: ${response.statusCode}');
    }
  }

  Future<WalletModel> getTransactionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/consumer/wallet/transaction'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return WalletModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['msg'] ?? 'Failed to fetch transaction history: ${response.statusCode}');
    }
  }
}