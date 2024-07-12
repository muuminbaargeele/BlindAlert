import 'package:blind_alert/Helpers/app_colors.dart';
import 'package:blind_alert/Helpers/app_text_style.dart';
import 'package:blind_alert/Helpers/utils.dart';
import 'package:flutter/material.dart';

class DriverInfo extends StatelessWidget {
  const DriverInfo({
    super.key, required this.title, required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Text(
            "$title:",
            style: TextStyle(
              color: AppColors.text.withOpacity(0.5),
              fontSize: calculateHeightRatio(16, context),
              fontWeight: AppTextStyles.light,
            ),
          ),
          widthSpace(5),
          Text(
            body,
            style: TextStyle(
              color: AppColors.text,
              fontSize: calculateHeightRatio(16, context),
              fontWeight: AppTextStyles.semibold,
            ),
          )
        ],
      ),
    );
  }
}
