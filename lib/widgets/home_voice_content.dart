import 'package:blind_alert/Providers/last_voice.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../Helpers/app_colors.dart';
import '../Helpers/app_text_style.dart';
import '../Helpers/utils.dart';
import '../models/last_voice_model.dart';

class HomeVoiceContent extends StatefulWidget {
  const HomeVoiceContent({
    super.key,
    required this.isAuduoPage,
    required this.updateIsAudioPage,
  });

  final bool isAuduoPage;
  final ValueChanged updateIsAudioPage;

  @override
  State<HomeVoiceContent> createState() => _HomeVoiceContentState();
}

class _HomeVoiceContentState extends State<HomeVoiceContent> {
  late LastVoice lastVoice;
  late Box box;
  bool isDriver = false;


  @override
  Widget build(BuildContext context) {
    final lastVoiceModelProvider = Provider.of<LastVoiceModelProvider>(context);
    return Expanded(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: isDriver
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          crossAxisAlignment:
              isDriver ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: isDriver,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => widget.updateIsAudioPage(true),
                      child: Text(
                        "Audio",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: AppTextStyles.semibold,
                          fontSize: calculateHeightRatio(14, context),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.updateIsAudioPage(false),
                      child: Text(
                        "Add new Passenger",
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: AppTextStyles.semibold,
                          fontSize: calculateHeightRatio(10, context),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Last Voice ${isDriver ? "Sent" : "received"}",
                    style: TextStyle(
                        color: AppColors.text,
                        fontSize: calculateHeightRatio(13, context),
                        fontWeight: AppTextStyles.semibold),
                  ),
                  Text(
                    lastVoiceModelProvider.isLoading
                        ? ""
                        : timeago
                            .format(lastVoiceModelProvider.lastVoice.createdDt),
                    style: TextStyle(
                        color: AppColors.text.withOpacity(0.5),
                        fontSize: calculateHeightRatio(12, context),
                        fontWeight: AppTextStyles.light),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isDriver,
              child: Text(
                "Record Voice",
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: AppTextStyles.semibold,
                  fontSize: calculateHeightRatio(14, context),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
