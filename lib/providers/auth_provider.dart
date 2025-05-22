import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinovo_app/api/auth_api.dart';
import 'package:spinovo_app/models/otp_model.dart';
import 'package:spinovo_app/models/user_model.dart';
import 'package:spinovo_app/utiles/constants.dart';

class AuthProvider with ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize auth state from SharedPreferences
  Future<void> initAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConstants.TOKEN);
    notifyListeners();
  }

  // Send OTP
  Future<OtpModel?> sendOtp(String mobile) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authApi.sendOtp(mobile);
      if (response.status == true) {
        return response;
      } else {
        _errorMessage = 'Failed to send OTP';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login user
  Future<bool> login(String mobile) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authApi.userLogin(mobile);
      if (response.status == true) {
        _token = response.data!.user!.accessToken;
        print('_token AuthProvider $_token');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.TOKEN, _token!);
        return true;
      } else {
        _errorMessage = 'Login failed';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Signup user
  Future<bool> signup(String name, String mobile, String livingType) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authApi.userSignup(name, mobile, livingType);
      if (response.status == true) {
        _token = response.data!.user!.accessToken;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.TOKEN, _token!);
        return true;
      } else {
        _errorMessage = 'Signup failed';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout user
  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.TOKEN);
    notifyListeners();
  }
}