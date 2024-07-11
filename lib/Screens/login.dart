import 'package:blind_alert/Screens/signup.dart';
import 'package:blind_alert/app_colors.dart';
import 'package:blind_alert/app_text_style.dart';
import 'package:blind_alert/utils.dart';
import 'package:blind_alert/widgets/is_driver_buttons.dart';
import 'package:blind_alert/widgets/login_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.isDriver});
   final bool? isDriver;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool isDriver = false;

   @override
  void initState() {
    super.initState();
    isDriver = widget.isDriver ?? false;
  }

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
                    "assets/images/bg.png"), // Replace with your asset image path
                fit: BoxFit
                    .fitHeight, // This will cover the entire widget area including behind the status bar
              ),
            ),
          ),
          // Add your app content here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: calculateHeightRatio(100, context)),
                  child: Text(
                    "Log in",
                    style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontSize: calculateHeightRatio(24, context),
                        fontWeight: AppTextStyles.semibold),
                  ),
                ),
                heightSpace(8),
                Text(
                  "Welcome back! Please sign in to proceed",
                  style: GoogleFonts.poppins(
                      color: AppColors.secondary,
                      fontSize: calculateHeightRatio(16, context),
                      fontWeight: AppTextStyles.regular),
                ),
                heightSpace(26),
                SizedBox(
                  height: calculateHeightRatio(38, context),
                  width: double.infinity,
                  child: Row(
                    children: [
                      IsDriverButtons(
                        isDriver: isDriver,
                        ontap: () => setState(
                          () => isDriver = false,
                        ),
                        image:
                            "assets/images/${isDriver ? "in_" : ""}active_blind.png",
                      ),
                      widthSpace(27),
                      IsDriverButtons(
                        isDriver: !isDriver,
                        ontap: () => setState(
                          () => isDriver = true,
                        ),
                        image:
                            "assets/images/${!isDriver ? "in_" : ""}active_bus.png",
                      )
                    ],
                  ),
                ),
                heightSpace(20),
                LoginContent(
                  isDriver: isDriver,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: calculateHeightRatio(14, context)),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.bold,
                                fontSize: calculateHeightRatio(13, context)),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

