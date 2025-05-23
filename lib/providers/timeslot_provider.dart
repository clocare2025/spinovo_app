import 'package:flutter/material.dart';
import 'package:spinovo_app/api/timeslot_api.dart';
import 'package:spinovo_app/models/timeslot_model.dart';

class TimeslotProvider with ChangeNotifier {
  final TimeSlotApi _timeSlotApi = TimeSlotApi();
  bool _isLoading = false;
  String? _errorMessage;
  TimeSlotModel? _timeSlot;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TimeSlotModel? get timeSlot => _timeSlot;

  Future<void> getTimeSlot() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _timeSlotApi.timeSlotGet();
      if (response.status == true) {
        _timeSlot = response;
      } else {
        _errorMessage = response.msg ?? 'Failed to create address';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
