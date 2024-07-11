class Payload {
    final String message;
    final dynamic data;

    Payload({required this.message, this.data});

    factory Payload.fromJson(Map<String, dynamic> json) {
        return Payload(
            message: json['message'] ?? 'No message provided',
            data: json['data'],  // Keep data dynamic or parse to a specific model if known
        );
    }
}
