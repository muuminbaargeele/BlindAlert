import 'package:blind_alert/Helpers/app_colors.dart';
import 'package:blind_alert/Helpers/utils.dart';
import 'package:blind_alert/Providers/get_user.dart';
import 'package:blind_alert/widgets/header.dart';
import 'package:blind_alert/widgets/navigation_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/home_deriver_info.dart';
import '../widgets/home_voice_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.isDriver, this.mobile, this.email});

  final bool isDriver;
  final String? mobile;
  final String? email;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isVoicePage = true;

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModelProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Header(
            widget: widget,
          ),
          isVoicePage
              ? HomeVoiceContent()
              : HomeDriverInfo(userModelProvider: userModelProvider),
          Container(
            height: calculateHeightRatio(80, context),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.secondaryWithOpacity,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                NavigationButtons(
                  isVoicePage: isVoicePage,
                  ontap: () => setState(() => isVoicePage = true),
                  image:
                      "assets/images/${isVoicePage ? "active_voice.png" : "in_active_voice.png"}",
                  text: "Voices",
                ),
                NavigationButtons(
                  isVoicePage: !isVoicePage,
                  ontap: () => setState(() => isVoicePage = false),
                  image:
                      "assets/images/${!isVoicePage ? "active_bus.png" : "in_active_bus.png"}",
                  text: "Driver",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
