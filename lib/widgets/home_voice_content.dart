import 'package:blind_alert/Providers/last_voice.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Helpers/app_colors.dart';
import '../Helpers/app_text_style.dart';
import '../Helpers/utils.dart';
import '../databases/end_points.dart';
import '../databases/network_utils.dart';
import '../models/last_voice_model.dart';

class HomeVoiceContent extends StatefulWidget {
  const HomeVoiceContent({
    super.key,
  });

  @override
  State<HomeVoiceContent> createState() => _HomeVoiceContentState();
}

class _HomeVoiceContentState extends State<HomeVoiceContent> {
  late LastVoice lastVoice;
  late Box box;

  Future<void> getVoice(String driverEmail) async {
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

  @override
  void initState() {
    super.initState();
    box = Hive.box('local_storage');
    String driverEmail = box.get('UserDriver');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getVoice(driverEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Base64AudioPlayer(base64Audio: widget.lastVoiceModelProvider.lastVoice.voiceBase64);
    final lastVoiceModelProvider = Provider.of<LastVoiceModelProvider>(context);
    return Expanded(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Last Voice received",
            style: TextStyle(
                color: AppColors.text,
                fontSize: calculateHeightRatio(13, context),
                fontWeight: AppTextStyles.semibold),
          ),
          Text(
            lastVoiceModelProvider.isLoading
                ? ""
                : timeago.format(lastVoiceModelProvider.lastVoice.createdDt),
            style: TextStyle(
                color: AppColors.text.withOpacity(0.5),
                fontSize: calculateHeightRatio(12, context),
                fontWeight: AppTextStyles.light),
          ),
        ],
      ),
    ));
  }
}
