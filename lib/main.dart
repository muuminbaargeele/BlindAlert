import 'dart:async';
import 'package:blind_alert/Firebase/firebase_api.dart';
import 'package:blind_alert/Providers/last_voice.dart';
import 'package:blind_alert/Screens/get_started.dart';
import 'package:blind_alert/Screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'Helpers/audio_player.dart';
import 'Providers/get_user.dart';
import 'databases/end_points.dart';
import 'databases/network_utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Ensure the setup is initialized
  await Hive.initFlutter();

  print("this is Body${message.notification!.title}");
  print("this is Body${message.notification!.body}");

  //   // Open the Hive box
  var box = await Hive.openBox('local_storage');
  String? driverEmail = box.get('UserDriver');
  final params = {"email": driverEmail};
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

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
    final firebaseApi = FirebaseApi();
    firebaseApi.requestNotification();
    // Ensure the setup is initialized
    await Hive.initFlutter();

    //   // Open the Hive box
    var box = await Hive.openBox('local_storage');
    String? driverEmail = box.get('UserDriver');
    print(driverEmail);
    if (driverEmail == null) {
      print("No User Found");
    } else {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }
    try {
      final appDocumentDir =
          await getApplicationDocumentsDirectory(); // Use path_provider
      Hive.init(appDocumentDir.path);
      await Hive.openBox('local_storage');
    } catch (e) {
      print("Hive Failed: $e");
    }
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserModelProvider()),
    ChangeNotifierProvider(create: (_) => LastVoiceModelProvider()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Making the status bar transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness:
          Brightness.dark, // Dark icons on the status bar for light backgrounds
    ));

    late Box box;
    box = Hive.box('local_storage');
    bool isLogin = box.get('isLogin', defaultValue: false);
    bool isDriver = box.get('isDriver', defaultValue: false);
    // print(box.get('UserDriver'));
    FirebaseApi().litsenAudio(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          // Use the GoogleFonts helper to get the Poppins font and set it as the default text theme
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: isLogin ? HomeScreen(isDriver: isDriver) : const GetStarted());
  }
}
