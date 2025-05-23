import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/timeslot_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class TimeSlotApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<TimeSlotModel> timeSlotGet() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/consumer/timeslots'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('texxxxxxxxxx ${response.body}');

      if (response.statusCode == 200) {
        return TimeSlotModel.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
            error['msg'] ?? 'Failed to create address: ${response.statusCode}');
      }
    } catch (e) {
      // You can also log this error or show a user-friendly message
      throw Exception('Failed to load User $e');
    }
  }
}
