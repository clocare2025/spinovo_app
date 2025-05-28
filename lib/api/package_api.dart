import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/package_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class PackageApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<PackageModel> fetchPackages() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/consumer/package/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return PackageModel.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
            error['msg'] ?? 'Failed to fetch packages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load packages: $e');
    }
  }
}