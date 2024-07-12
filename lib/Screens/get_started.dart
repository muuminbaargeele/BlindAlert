import 'package:blind_alert/Screens/login.dart';
import 'package:blind_alert/Screens/signup.dart';
import 'package:blind_alert/widgets/primarybutton.dart';
import 'package:flutter/material.dart';
import 'package:blind_alert/Helpers/utils.dart';
import 'package:blind_alert/Helpers/app_colors.dart';
import 'package:blind_alert/Helpers/app_text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/get_start_bg.png"), // Replace with your asset image path
                fit: BoxFit
                    .fitHeight, // This will cover the entire widget area including behind the status bar
              ),
            ),
          ),
          // Add your app content here
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: calculateHeightRatio(297, context),
              decoration: BoxDecoration(
                color: AppColors.container, // Background color of the container
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), // Top left corner radius
                  topRight: Radius.circular(20), // Top right corner radius
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                        0.12), // Shadow color with some transparency
                    spreadRadius: 0, // Extent of the shadow spread
                    blurRadius: 8.6, // How blurred the shadow should be
                    offset: const Offset(
                        0, -4), // Horizontal and vertical offset of the shadow
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 30, 20, 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BlindAlert helps you navigate safely and independently',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: AppColors.secondary,
                          fontWeight: AppTextStyles.semibold,
                          fontSize: calculateHeightRatio(20, context)),
                    ),
                    Column(
                      children: [
                        Primarybutton(
                          btntext: "Get Started",
                          fontclr: AppColors.primaryText,
                          color: AppColors.primary,
                          width: double.infinity,
                          ontap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()),
                              (Route<dynamic> route) => false),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Primarybutton(
                          btntext: "I have an account",
                          fontclr: AppColors.text,
                          color: AppColors.secondary,
                          width: double.infinity,
                          ontap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                                (Route<dynamic> route) => false);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
