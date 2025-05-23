import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class AddressApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<AddressModel> createAddress(Map<String, dynamic> addressData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/consumer/address/create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addressData),
    );

    if (response.statusCode == 200) {
      return AddressModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['msg'] ?? 'Failed to create address: ${response.statusCode}');
    }
  }
}