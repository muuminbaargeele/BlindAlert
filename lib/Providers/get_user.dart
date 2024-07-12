import 'package:flutter/material.dart';
import '../models/Driver/driver_model.dart';
import '../models/Passenger/passenger_model.dart';

class UserModelProvider with ChangeNotifier {
  late PassengerModel _passengerModel;
  late DriverModel _driverModel;
  bool _isLoading = true;

  PassengerModel get passengerModel => _passengerModel;
  DriverModel get driverModel => _driverModel;
  bool get isLoading => _isLoading;

  void setPassengerModel(PassengerModel passengerModel) {
    _passengerModel = passengerModel;
    notifyListeners();
  }

  void setDriverModel(DriverModel driverModel) {
    _driverModel = driverModel;
    notifyListeners();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
