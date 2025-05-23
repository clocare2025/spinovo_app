import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spinovo_app/models/otp_model.dart';
import 'package:spinovo_app/models/user_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class AuthApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<OtpModel> sendOtp(String number) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/consumer/auth/send-otp"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'mobile': number}),
    );

    if (response.statusCode == 200) {
      return OtpModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send OTP: ${response.body}');
    }
  }

  Future<UserModel> userSignup(String name, String mobileNo, String livingType) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/consumer/auth/signup"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'name': name,
        'mobile': mobileNo,
        'livingType': livingType,
      }),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to signup: ${response.body}');
    }
  }

  Future<UserModel> userLogin(String mobileNo) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/consumer/auth/login"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'mobile': mobileNo}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}