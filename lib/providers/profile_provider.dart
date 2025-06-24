import 'package:flutter/material.dart';
import 'package:spinovo_app/api/profile_api.dart';
import 'package:spinovo_app/models/user_model.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileApi _profileApi = ProfileApi();
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserProfile() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _profileApi.getUserProfile();
      if (response.status == true) {
        _userProfile = response;
      } else {
        _errorMessage = response.msg ?? 'Failed to fetch profile';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserProfile(String name, String email, String livingType) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _profileApi.updateUserProfile(name, email, livingType);
      if (response.status == true) {
        _userProfile = response;
        return true;
      } else {
        _errorMessage = response.msg ?? 'Failed to update profile';
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
}