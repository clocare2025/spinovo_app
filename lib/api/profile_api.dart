import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/user_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class ProfileApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<UserModel> getUserProfile() async {
        final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);
    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/consumer/profile"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }

  Future<UserModel> updateUserProfile( String name, String email, String livingType) async {
        final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/consumer/profile/update"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'livingType': livingType,
      }),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }
}