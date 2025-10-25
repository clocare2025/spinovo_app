// Add this new file: lib/api/package_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/subscription_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class PackageSubscripionApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<SubscriptionModel> getSubscriptionList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/consumer/subscription'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return SubscriptionModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['msg'] ?? 'Failed to fetch subscription list: ${response.statusCode}');
    }
  }

  // Assuming there is a buy/subscribe API endpoint. Adjust the URL and body as per actual API.
  // For now, placeholder for buying a package. You need to replace with actual endpoint if available.
  Future<Map<String, dynamic>> buyPackage(Map<String, dynamic> packageDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/consumer/subscription/subscribe'), // Replace with actual subscribe endpoint
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(packageDetails), // e.g., {'subscription_id': id, 'plan_validity': validity, 'sub_plan_clothes': clothes}
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['msg'] ?? 'Failed to buy package: ${response.statusCode}');
    }
  }
}