import 'package:blind_alert/Helpers/audio_player.dart';
import 'package:blind_alert/Providers/get_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../Providers/last_voice.dart';
import '../databases/end_points.dart';
import '../databases/network_utils.dart';
import '../models/last_voice_model.dart';

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

  Future<void> litsenAudio(context) async {
    UserModelProvider userModelProvider =
        Provider.of<UserModelProvider>(context);
    if (userModelProvider.isLoading) {
      print(
          'Driver email is not available in local storage. ${userModelProvider.isLoading}');
      return;
    }
    String driverEmail = userModelProvider.passengerModel.driverEmail;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        getVoice(driverEmail, context);
      }
    });
  }

  Future<void> getVoice(String driverEmail, context) async {
    late LastVoice lastVoice;
    final lastVoiceModelProvider =
        Provider.of<LastVoiceModelProvider>(context, listen: false);
    lastVoiceModelProvider.setLoading(true);
    final params = {"email": driverEmail};
    print(params);
    try {
      final response = await NetworkUtil.postData(getLastVoiceEndPoint, params);
      if (response.isSuccess) {
        lastVoice = lastVoiceFromJson(response.payload!.data);
        lastVoiceModelProvider.setLastVoiceModel(lastVoice);
        Base64AudioPlayer(
            base64Audio: lastVoiceModelProvider.lastVoice.voiceBase64);
        lastVoiceModelProvider.setLoading(false);
      } else {
        print(response.error?.message ?? "Unknown error occurred");
        lastVoiceModelProvider.setLoading(true);
      }
    } catch (e) {
      print("$e");
      lastVoiceModelProvider.setLoading(true);
    }
  }

  Future<void> getBackgroundVoice() async {
    // Ensure the setup is initialized
    await Hive.initFlutter();

    //   // Open the Hive box
    var box = await Hive.openBox('local_storage');
    String? driverEmail = box.get('UserDriver');
    final params = {"email": driverEmail};
    print(params);
    try {
      final response = await NetworkUtil.postData(getLastVoiceEndPoint, params);
      if (response.isSuccess) {
        String base64Audio = response.payload!.data["voiceBase64"];
        Base64AudioPlayer(base64Audio: base64Audio);
      } else {
        print(response.error?.message ?? "Unknown error occurred");
      }
    } catch (e) {
      print("$e");
    }
  }
}
