import 'package:blind_alert/app_colors.dart';
import 'package:blind_alert/app_text_style.dart';
import 'package:blind_alert/utils.dart';
import 'package:blind_alert/widgets/mytextfield.dart';
import 'package:blind_alert/widgets/primarybutton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({
    super.key,
    required this.isDriver,
  });

  final bool isDriver;

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  String emailError = "";
  TextEditingController emailController = TextEditingController();
  String phoneError = "";
  TextEditingController phoneController = TextEditingController();
  String passwordError = "";
  TextEditingController passwordController = TextEditingController();

  bool isEyeOn = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.isDriver
              ? [
                  Text(
                    "Email",
                    style: GoogleFonts.poppins(
                      color: AppColors.text,
                      fontSize: calculateHeightRatio(14, context),
                      fontWeight: AppTextStyles.regular,
                    ),
                  ),
                  MyTextField(
                      errorName: emailError,
                      controller: emailController,
                      text: "Your Email",
                      textInputType: TextInputType.emailAddress,
                      padding: 6),
                  heightSpace(16),
                  Text(
                    "Password",
                    style: GoogleFonts.poppins(
                      color: AppColors.text,
                      fontSize: calculateHeightRatio(14, context),
                      fontWeight: AppTextStyles.regular,
                    ),
                  ),
                  MyTextField(
                    errorName: passwordError,
                    controller: passwordController,
                    text: "Your Password",
                    textInputType: TextInputType.visiblePassword,
                    padding: 6,
                    isPassword: true,
                    eyeOn: isEyeOn,
                    eyeChange: () => setState(() => isEyeOn = !isEyeOn),
                  ),
                ]
              : [
                  Text(
                    "Mobile",
                    style: GoogleFonts.poppins(
                      color: AppColors.text,
                      fontSize: calculateHeightRatio(14, context),
                      fontWeight: AppTextStyles.regular,
                    ),
                  ),
                  MyTextField(
                    errorName: phoneError,
                    controller: phoneController,
                    text: "Your Mobile",
                    textInputType: TextInputType.emailAddress,
                    padding: 6,
                  ),
                ],
        ),
        heightSpace(40),
        Primarybutton(
          btntext: "Login",
          fontclr: AppColors.primaryText,
          color: AppColors.primary,
          width: double.infinity,
          ontap: () {},
        ),
      ],
    );
  }
}
