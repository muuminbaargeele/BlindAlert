class ApiError {
    final int statusCode;
    final String message;

    ApiError({required this.statusCode, required this.message});

    factory ApiError.fromJson(Map<String, dynamic> json) {
        return ApiError(
            statusCode: json['statusCode'],
            message: json['message'],
        );
    }
}
