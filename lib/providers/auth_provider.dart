// import 'package:flutter/material.dart';
// import '../api/api_service.dart';
// import '../models/user.dart';
// import '../services/secure_storage_service.dart';
// import '../services/navigation_service.dart';

// class AuthProvider with ChangeNotifier {
//   User? _user;
//   String? _accessToken;
//   bool _isLoading = false;

//   User? get user => _user;
//   String? get accessToken => _accessToken;
//   bool get isLoading => _isLoading;

//   final ApiService _apiService =  ();
//   final SecureStorageService _storageService = SecureStorageService();

//   Future<void> checkAuthStatus() async {
//     _accessToken = await _storageService.read('access_token');
//     if (_accessToken != null) {
//       // Fetch user data or validate token
//       NavigationService.navigateTo('/home');
//     } else {
//       NavigationService.navigateTo('/phone');
//     }
//   }

//   Future<void> sendOtp(String phoneNumber) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       await _apiService.sendOtp(phoneNumber);
//       NavigationService.navigateTo('/otp', arguments: phoneNumber);
//     } catch (e) {
//       // Handle error
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> verifyOtp(String phoneNumber, String otp) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final response = await _apiService.verifyOtp(phoneNumber, otp);
//       _accessToken = response['access_token'];
//       await _storageService.write('access_token', _accessToken!);
//       if (response['is_new_user']) {
//         NavigationService.navigateTo('/customer-details');
//       } else {
//         _user = User.fromJson(response['user']);
//         NavigationService.navigateTo('/home');
//       }
//     } catch (e) {
//       // Handle error
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> registerUser(Map<String, dynamic> userData) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final response = await _apiService.registerUser(userData);
//       _user = User.fromJson(response['user']);
//       NavigationService.navigateTo('/address');
//     } catch (e) {
//       // Handle error
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> addAddress(Map<String, dynamic> addressData) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       await _apiService.addAddress(addressData, _accessToken!);
//       NavigationService.navigateTo('/home');
//     } catch (e) {
//       // Handle error
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }