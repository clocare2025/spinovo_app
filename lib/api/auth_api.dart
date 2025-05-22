import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/models/otp_model.dart';
import 'package:spinovo_app/models/user_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class AuthApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<OtpModel> sendOtp(String number) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/consumer/auth/send-otp"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile': number,
      }),
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return OtpModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load User');
    }
  }

  Future<UserModel> userSignup(
      String name, String mobileNo, String livingType) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/consumer/auth/signup"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'mobile': mobileNo,
        'livingType': livingType,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load User');
    }
  }

  Future<UserModel> userLogin(String mobileNo) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/consumer/auth/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile': mobileNo,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load User');
    }
  }
}
