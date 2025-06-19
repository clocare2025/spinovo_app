import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/order_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class OrderApi {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<OrderModel> booking(Map<String, dynamic> bookingDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/consumer/order/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(bookingDetails),
      );
      print('wastik order api call ${response.body}');
      if (response.statusCode == 200) {
        return OrderModel.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
            error['msg'] ?? 'Failed to create booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Order>> getList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/consumer/order/list'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        final ordersList = jsonResponse['data']['orders'] as List;
        return ordersList.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception(jsonResponse['msg'] ?? 'Failed to fetch order list');
      }
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['msg'] ?? 'Failed to fetch order list: ${response.statusCode}');
    }
  }

  Future<OrderModel> cancel(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/consumer/order/cancel/$bookingId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return OrderModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['msg'] ?? 'Failed to cancel booking: ${response.statusCode}');
    }
  }
}
