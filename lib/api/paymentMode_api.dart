import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/paymentMode_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class PaymentModeApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<PaymentModeModel> fetchPaymentModes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/consumer/payment-mode/check'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return PaymentModeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch payment modes: ${response.statusCode}');
    }
  }
}
