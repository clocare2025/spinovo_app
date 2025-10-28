// lib/api/package_subscription_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/subscription_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class PackageSubscriptionApi {
  static const String _base = AppConstants.BASE_URL;

  // -----------------------------------------------------------------------
  //  GET  /api/v1/consumer/subscription   →  list of packages
  // -----------------------------------------------------------------------
  Future<SubscriptionModel> getSubscriptionList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final uri = Uri.parse('$_base/api/v1/consumer/subscription');
    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      return SubscriptionModel.fromJson(jsonDecode(resp.body));
    }

    final err = jsonDecode(resp.body);
    throw Exception(err['msg'] ??
        'Failed to fetch subscription list: ${resp.statusCode}');
  }

  // -----------------------------------------------------------------------
  //  POST  /api/v1/consumer/subscription/buy   →  purchase a package
  // -----------------------------------------------------------------------
  /// **body** must contain exactly the fields the server expects:
  /// {
  ///   "address_id": "...",
  ///   "subscription_id": 1,
  ///   "name": "Ironing",
  ///   "validity": 30,
  ///   "clothes": 100,
  ///   "discount_rate": 15,
  ///   "prices": 500,
  ///   "no_of_pickups": 4,
  ///   "total_billing": 500,
  ///   "payment_mode": "Online",
  ///   "transaction_id": "eiwquir3434",
  ///   "start_date": "10/28/2025",
  ///   "start_time": "03:03 PM"
  /// }
  Future<Map<String, dynamic>> buyPackage(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final uri = Uri.parse('$_base/api/v1/consumer/subscription/buy');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    final json = jsonDecode(resp.body);
    if (resp.statusCode == 200 && json['status'] == true) {
      return json; // contains {status:true, msg:..., data:{subscription:...}}
    }

    throw Exception(json['msg'] ?? 'Buy failed – ${resp.statusCode}');
  }
}