import 'package:blind_alert/Firebase/firebase_api.dart';
import 'package:blind_alert/Helpers/app_colors.dart';
import 'package:blind_alert/Helpers/app_text_style.dart';
import 'package:blind_alert/Helpers/utils.dart';
import 'package:blind_alert/Screens/home.dart';
import 'package:blind_alert/databases/end_points.dart';
import 'package:blind_alert/databases/network_utils.dart';
import 'package:blind_alert/widgets/mytextfield.dart';
import 'package:blind_alert/widgets/primarybutton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../Providers/get_user.dart';
import '../models/Passenger/passenger_model.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({
    super.key,
    required this.isDriver,
    required this.box,
  });

  final bool isDriver;
  final Box box;

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
  bool isLoading = false;

  late PassengerModel passengerModel;

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
          isLoading: isLoading,
          ontap: () {
            widget.isDriver
                ? {
                    emailController.text.isEmpty ||
                            passwordController.text.isEmpty
                        ? setState(() {
                            emailError = emailController.text.isEmpty
                                ? "Please enter an Email"
                                : "";
                            passwordError = passwordController.text.isEmpty
                                ? "Please enter a Password"
                                : "";
                          })
                        : performLogin(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                            box: widget.box),
                  }
                : {
                    phoneController.text.isEmpty
                        ? setState(() {
                            phoneError = phoneController.text.isEmpty
                                ? "Please enter a Mobile"
                                : "";
                          })
                        : performLogin(
                            mobile: phoneController.text,
                            context: context,
                            box: widget.box),
                  };
          },
        ),
      ],
    );
  }

  // Login Fucntion
  Future<void> performLogin(
      {String email = "",
      String password = "",
      String mobile = "",
      required BuildContext context,
      required Box box}) async {
    setState(() => isLoading = true);
    bool isDriver = mobile.isEmpty;
    String token = "";
    if (!isDriver) {
      final firebaseApi = FirebaseApi();
      token = await firebaseApi.getToken();
      print("Passenger Token is $token");
    }

    String endpoint =
        mobile.isNotEmpty ? passengerLoginEndPoint : driverLoginEndPoint;
    final params = mobile.isNotEmpty
        ? {"phoneNumber": mobile, "fcmToken": token}
        : {"email": email, "password": password};

    try {
      final response = await NetworkUtil.postData(endpoint, params);
      if (response.isSuccess) {
        // Handle successful login
        getUser(mobile, isDriver, email, box);
      } else {
        showErrorSnackBar(
            context, response.error?.message ?? "Unknown error occurred");
      }
    } catch (e) {
      print("$e");
      showErrorSnackBar(context, "Failed to connect. Check your network.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  Future<void> getUser(mobile, isDriver, email, Box box) async {
    final userModelProvider =
        Provider.of<UserModelProvider>(context, listen: false);
    final params = {"phoneNumber": mobile};
    try {
      final response = await NetworkUtil.postData(getPassengerEndPoint, params);
      if (response.isSuccess) {
        passengerModel = passengerModelFromJson(response.payload!.data);
        userModelProvider.setPassengerModel(passengerModel);
        box.put("UserDriver", userModelProvider.passengerModel.driverEmail);
        box.put("UserId", isDriver ? email : mobile);
        box.put("isLogin", true);
        box.put("isDriver", isDriver);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => HomeScreen(
                      isDriver: isDriver,
                      mobile: mobile,
                      email: email,
                    )),
            (Route<dynamic> route) => false);
      } else {
        showErrorSnackBar(
            context, response.error?.message ?? "Unknown error occurred");
      }
    } catch (e) {
      print("$e");
      showErrorSnackBar(context, "Failed to connect. Check your network.");
    }
  }
}
