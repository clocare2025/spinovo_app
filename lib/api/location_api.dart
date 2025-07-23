import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/location_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class LocationApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<LocationModel> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);
    print("Token LocationApi: $token"); // Debug token
    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/consumer/service/location/list"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print("API Response: ${response.body}"); // Debug API response

    if (response.statusCode == 200) {
      return LocationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }
}
