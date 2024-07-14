import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blind_alert/Helpers/app_colors.dart';
import 'package:blind_alert/Providers/last_voice.dart';
import 'package:blind_alert/databases/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../Helpers/utils.dart';
import '../databases/end_points.dart';
import '../models/last_voice_model.dart';

class Recorder extends StatefulWidget {
  const Recorder({
    super.key,
  });

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  bool isLoading = false;
  FlutterSoundRecorder? _recorder;
  String? _filePath;
  String? _base64String;
  Timer? _timer;
  Duration _recordDuration = Duration.zero;
  Timer? _recordDurationTimer;
  String? driverEmail;
  late LastVoice lastVoice;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initializeRecorder();

    late Box box;
    box = Hive.box('local_storage');
    driverEmail = box.get('UserId');
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    // await Permission.storage.request();

    if (await Permission.microphone.isGranted) {
      await _recorder!.openRecorder();
    } else {
      throw RecordingPermissionException(
          "Microphone or Storage permission not granted");
    }
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    _filePath = '${directory.path}/audio.aac';
    await _recorder!.startRecorder(toFile: _filePath);
    setState(() {});

    // Start a timer to stop recording after 2 minutes
    _timer = Timer(Duration(minutes: 2), _stopRecording);

    // Start a timer to update the recording duration
    _recordDuration = Duration.zero;
    _recordDurationTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _recordDuration = Duration(seconds: _recordDuration.inSeconds + 1);
      });
    });
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    _timer?.cancel();
    _recordDurationTimer?.cancel();
    _convertAudioToBase64();
    setState(() {});
  }

  Future<void> _convertAudioToBase64() async {
    if (_filePath != null) {
      final audioFile = File(_filePath!);
      if (await audioFile.exists()) {
        final fileBytes = await audioFile.readAsBytes();
        _base64String = base64Encode(fileBytes);
        print(_base64String);
        sendVoice(voiceBase64: _base64String!, context: context);
        setState(() {});
      } else {
        print("File does not exist at $_filePath");
      }
    }
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
    _timer?.cancel();
    _recordDurationTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: calculateHeightRatio(45, context),
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 40),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: AppColors.secondaryWithOpacity,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11.0),
            child: Image.asset(_recorder!.isRecording
                ? "assets/images/recording.png"
                : "assets/images/record.png"),
          ),
          widthSpace(5),
          Text(_recorder!.isRecording
              ? "${_formatDuration(_recordDuration)}"
              : "Start Recording -->"),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _recorder!.isRecording ? _stopRecording() : _startRecording();
            },
            child: Container(
              height: calculateHeightRatio(30, context),
              width: calculateHeightRatio(30, context),
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.asset(_recorder!.isRecording
                      ? "assets/images/pause.png"
                      : "assets/images/voice_icon.png"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // upload Voice
  Future<void> sendVoice({
    required String voiceBase64,
    required BuildContext context,
  }) async {
    setState(() => isLoading = true);

    String endpoint = sendVoiceEndPoint;
    final params = {"voiceBase64": voiceBase64, "senderEmail": driverEmail};

    try {
      final response = await NetworkUtil.postData(endpoint, params);
      if (response.isSuccess) {
        // Handle successful login
        String message = response.payload!.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
        getVoice(driverEmail!);
      } else {
        showErrorSnackBar(
            context, response.error?.message ?? "Unknown error occurred");
      }
    } catch (e) {
      showErrorSnackBar(context, "Failed to connect. Check your network.");
    } finally {
      setState(() => isLoading = false);
    }
  }

// get last voice
  Future<void> getVoice(String driverEmail) async {
    final lastVoiceModelProvider =
        Provider.of<LastVoiceModelProvider>(context, listen: false);
    // lastVoiceModelProvider.setLoading(true);
    final params = {"email": driverEmail};
    print(params);
    try {
      final response = await NetworkUtil.postData(getLastVoiceEndPoint, params);
      if (response.isSuccess) {
        lastVoice = lastVoiceFromJson(response.payload!.data);
        lastVoiceModelProvider.setLastVoiceModel(lastVoice);
        lastVoiceModelProvider.setLoading(false);
      } else {
        showErrorSnackBar(
            context, response.error?.message ?? "Unknown error occurred");
        lastVoiceModelProvider.setLoading(true);
      }
    } catch (e) {
      print("$e");
      showErrorSnackBar(context, "Failed to connect. Check your network.");
      lastVoiceModelProvider.setLoading(true);
    }
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
