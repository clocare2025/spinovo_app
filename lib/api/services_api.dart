import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/services_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class ServicesApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<ServicesModel> serviceList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/consumer/service/category'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ServicesModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['msg'] ?? 'Failed to fetch services: ${response.statusCode}');
    }
  }
}