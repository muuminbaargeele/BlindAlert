import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  Future<String> getToken() async {
    try {
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("Done. Token: $fcmToken");
      return fcmToken ?? "No Token Found";
    } catch (e) {
      print("Failed: $e");
      return e.toString();
    }
  }

  Future<void> requestNotification() async {
    await FirebaseMessaging.instance.requestPermission();
  }
}
