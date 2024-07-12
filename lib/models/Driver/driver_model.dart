// To parse this JSON data, do
//
//     final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

import '../Passenger/passenger_model.dart';

DriverModel driverModelFromJson(Map<String, dynamic> str) =>
    DriverModel.fromJson(str);

String driverModelToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final DateTime createdDt;
  final List<PassengerModel> passengers;

  DriverModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.createdDt,
    required this.passengers,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json["id"],
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        createdDt: DateTime.parse(json["createdDT"]),
        passengers: List<PassengerModel>.from(
            json["passengers"].map((x) => PassengerModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "email": email,
        "createdDT": createdDt.toIso8601String(),
        "passengers": List<dynamic>.from(passengers.map((x) => x.toJson())),
      };
}
