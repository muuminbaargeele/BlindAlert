// To parse this JSON data, do
//
//     final lastVoice = lastVoiceFromJson(jsonString);

import 'dart:convert';

LastVoice lastVoiceFromJson(Map<String, dynamic> str) =>
    LastVoice.fromJson(str);

String lastVoiceToJson(LastVoice data) => json.encode(data.toJson());

class LastVoice {
  final int id;
  final String voiceBase64;
  final String senderEmail;
  final String senderPhoneNumber;
  final DateTime createdDt;

  LastVoice({
    required this.id,
    required this.voiceBase64,
    required this.senderEmail,
    required this.senderPhoneNumber,
    required this.createdDt,
  });

  factory LastVoice.fromJson(Map<String, dynamic> json) => LastVoice(
        id: json["id"],
        voiceBase64: json["voiceBase64"],
        senderEmail: json["senderEmail"],
        senderPhoneNumber: json["senderPhoneNumber"],
        createdDt: DateTime.parse(json["createdDT"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "voiceBase64": voiceBase64,
        "senderEmail": senderEmail,
        "senderPhoneNumber": senderPhoneNumber,
        "createdDT": createdDt.toIso8601String(),
      };
}
