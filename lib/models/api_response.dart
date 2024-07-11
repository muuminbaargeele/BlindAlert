import 'dart:convert';

import 'package:blind_alert/models/api_error.dart';
import 'package:blind_alert/models/payload_model.dart';

class ApiResponse {
  final int statusCode;
  final Payload? payload;
  final ApiError? error;

  ApiResponse({required this.statusCode, required this.payload, this.error});

  factory ApiResponse.fromRawJson(String str) =>
      ApiResponse.fromJson(json.decode(str));

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'],
      payload: Payload.fromJson(json['payload'] ?? {}),
      error: json['error'] != null ? ApiError.fromJson(json['error']) : null,
    );
  }

  bool get isSuccess => statusCode == 200;
}
