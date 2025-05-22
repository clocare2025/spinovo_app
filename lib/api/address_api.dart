import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/utiles/constants.dart';


class AddressApiService {
  static const String baseUrl = AppConstants.BASE_URL;

  Future<Address> createAddress(Map<String, dynamic> addressData, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/consumer/address/create'),
      body: jsonEncode(addressData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final json = jsonDecode(response.body);
    if (json['status'] == true) {
      return Address.fromJson(json['data']['address']);
    } else {
      throw Exception(json['msg'] ?? 'Failed to create address');
    }
  }

  Future<List<Address>> getAddressList(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/consumer/address/list'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final json = jsonDecode(response.body);
    if (json['status'] == true) {
      return (json['data']['address'] as List)
          .map((item) => Address.fromJson(item))
          .toList();
    } else {
      throw Exception(json['msg'] ?? 'Failed to fetch address list');
    }
  }

  Future<void> deleteAddress(String addressId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/consumer/address/delete/$addressId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final json = jsonDecode(response.body);
    if (json['status'] != true) {
      throw Exception(json['msg'] ?? 'Failed to delete address');
    }
  }
}