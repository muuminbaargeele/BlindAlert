// To parse this JSON data, do
//
//     final passengerModel = passengerModelFromJson(jsonString);

import 'dart:convert';

PassengerModel passengerModelFromJson(Map<String, dynamic> str) => PassengerModel.fromJson(str);

String passengerModelToJson(PassengerModel data) => json.encode(data.toJson());

class PassengerModel {
    final int id;
    final String fullName;
    final String phoneNumber;
    final String location;
    final DateTime createdDt;
    final String driverEmail;
    final String driverPhoneNumber;
    final String driverName;

    PassengerModel({
        required this.id,
        required this.fullName,
        required this.phoneNumber,
        required this.location,
        required this.createdDt,
        required this.driverEmail,
        required this.driverPhoneNumber,
        required this.driverName,
    });

    factory PassengerModel.fromJson(Map<String, dynamic> json) => PassengerModel(
        id: json["id"],
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
        location: json["location"],
        createdDt: DateTime.parse(json["createdDT"]),
        driverEmail: json["driverEmail"],
        driverPhoneNumber: json["driverPhoneNumber"],
        driverName: json["driverName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "location": location,
        "createdDT": createdDt.toIso8601String(),
        "driverEmail": driverEmail,
        "driverPhoneNumber": driverPhoneNumber,
        "driverName": driverName,
    };
}
