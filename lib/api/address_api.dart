import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/models/address_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class AddressApi {
  static const String baseUrl = AppConstants.BASE_URL;

  // Create a new address
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

  // Fetch list of addresses
  Future<List<AddressData>> getAddressList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/consumer/address/list'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        final addressList = jsonResponse['data']['address'] as List;
        return addressList.map((address) => AddressData.fromJson(address)).toList();
      } else {
        throw Exception(jsonResponse['msg'] ?? 'Failed to fetch address list');
      }
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['msg'] ?? 'Failed to fetch address list: ${response.statusCode}');
    }
  }

  // Delete an address
  Future<void> deleteAddress(String addressId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/consumer/address/delete/$addressId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] != true) {
        throw Exception(jsonResponse['msg'] ?? 'Failed to delete address');
      }
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['msg'] ?? 'Failed to delete address: ${response.statusCode}');
    }
  }
}






// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spinovo_app/models/address_model.dart';
// import 'package:spinovo_app/utiles/constants.dart';

// class AddressApi {
//   static const String baseUrl = AppConstants.BASE_URL;

//   Future<AddressModel> createAddress(Map<String, dynamic> addressData) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(AppConstants.TOKEN);

//     if (token == null || token.isEmpty) {
//       throw Exception('Authentication token is missing');
//     }

//     final response = await http.post(
//       Uri.parse('$baseUrl/api/v1/consumer/address/create'),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(addressData),
//     );

//     if (response.statusCode == 200) {
//       return AddressModel.fromJson(jsonDecode(response.body));
//     } else {
//       final error = jsonDecode(response.body);
//       throw Exception(error['msg'] ?? 'Failed to create address: ${response.statusCode}');
//     }
//   }
// }