import 'dart:convert';

import 'package:blind_alert/models/api_error.dart';
import 'package:blind_alert/models/api_response.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
    static Future<ApiResponse> postData(String url, Map<String, dynamic> body) async {
        try {
            final response = await http.post(
                Uri.parse(url),
               headers: {"Content-Type": "application/json"},
                body: jsonEncode(body),
            );

            return ApiResponse.fromRawJson(response.body);
        } catch (e) {
          print(e);
            return ApiResponse(
                statusCode: 500,
                error: ApiError(statusCode: 500, message: 'An error occurred: $e'), payload: null,
            );
        }
    }
}
