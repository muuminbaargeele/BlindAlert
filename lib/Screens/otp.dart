import 'package:blind_alert/Screens/login.dart';
import 'package:blind_alert/Helpers/app_colors.dart';
import 'package:blind_alert/Helpers/app_text_style.dart';
import 'package:blind_alert/databases/end_points.dart';
import 'package:blind_alert/databases/network_utils.dart';
import 'package:blind_alert/Helpers/utils.dart';
import 'package:blind_alert/widgets/errorcatch.dart';
import 'package:blind_alert/widgets/otptextfield.dart';
import 'package:blind_alert/widgets/primarybutton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otp = "";
  String otpError = "";
  bool isLoading = false;

  otpValidate(otp) {
    setState(() {
      otpError = otp.isEmpty ? "Please Enter OTP Code" : "";
    });
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
                    "Enter Code",
                    style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontSize: calculateHeightRatio(24, context),
                        fontWeight: AppTextStyles.semibold),
                  ),
                ),
                heightSpace(8),
                Text(
                  "We’ve sent an Email with an OTP to your Email ${widget.email} ",
                  style: GoogleFonts.poppins(
                      color: AppColors.secondary,
                      fontSize: calculateHeightRatio(16, context),
                      fontWeight: AppTextStyles.regular),
                ),
                heightSpace(50),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: calculateHeightRatio(245, context),
                        child: AdvancedOtpTextField(
                          onOtpEntered: (enteredOtp) {
                            if (kDebugMode) {
                              print("Code is $enteredOtp");
                            }
                            setState(() {
                              otp = enteredOtp;
                            });
                          },
                          error: otpError != "",
                        ),
                      ),
                      ErrorCatch(errorName: otpError),
                    ],
                  ),
                ),
                heightSpace(30),
                Primarybutton(
                  btntext: "Verify",
                  fontclr: AppColors.primaryText,
                  color: AppColors.primary,
                  width: double.infinity,
                  isLoading: isLoading,
                  ontap: () => performOTP(
                      email: widget.email, otp: otp, context: context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // OTP Fucntion
  Future<void> performOTP({
    required String email,
    required String otp,
    required BuildContext context,
  }) async {
    otpValidate(otp);

    if (otpError.isEmpty) {
      setState(() => isLoading = true);

      String endpoint = driverOTPEndPoint;
      final params = {
        "email": email,
        "otp": int.parse(otp),
      };

      try {
        final response = await NetworkUtil.postData(endpoint, params);
        if (response.isSuccess) {
          // Handle successful login
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Successfully! Please Log in"),
            backgroundColor: Colors.green,
          ));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen(isDriver: true,)),
              (Route<dynamic> route) => false);
        } else {
          setState(() {
            otpError = response.error!.message;
          });
        }
      } catch (e) {
        showErrorSnackBar(context, "Failed to connect. Check your network.");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
