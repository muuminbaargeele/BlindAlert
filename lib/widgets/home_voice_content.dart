import 'package:blind_alert/Providers/last_voice.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Helpers/app_colors.dart';
import '../Helpers/app_text_style.dart';
import '../Helpers/utils.dart';

class HomeVoiceContent extends StatelessWidget {
  const HomeVoiceContent({
    super.key,
    required this.lastVoiceModelProvider,
  });
  final LastVoiceModelProvider lastVoiceModelProvider;

  @override
  Widget build(BuildContext context) {
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
