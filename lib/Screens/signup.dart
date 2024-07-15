import 'package:blind_alert/databases/end_points.dart';
import 'package:blind_alert/databases/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blind_alert/Screens/login.dart';
import 'package:blind_alert/Screens/otp.dart';
import 'package:blind_alert/Helpers/app_colors.dart';
import 'package:blind_alert/Helpers/app_text_style.dart';
import 'package:blind_alert/Helpers/utils.dart';
import 'package:blind_alert/widgets/mytextfield.dart';
import 'package:blind_alert/widgets/primarybutton.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String nameError = "";
  TextEditingController nameController = TextEditingController();
  String mobileError = "";
  TextEditingController mobileController = TextEditingController();
  String emailError = "";
  TextEditingController emailController = TextEditingController();
  String passwordError = "";
  TextEditingController passwordController = TextEditingController();

  bool isEyeOn = false;
  bool isLoading = false;

  validation(
    name,
    phone,
    email,
    pass,
  ) {
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@gmail.com$');
    final RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
    final RegExp passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@!$%^&*()\-_=+{};:,<.>]{8,}$');
    final RegExp phoneRegex = RegExp(r"^[6]\d{8}$");

    setState(() {
      emailError = email.isEmpty
          ? "Please Enter a Email"
          : emailRegex.hasMatch(email)
              ? ""
              : "Invalid Email";
      nameError = name.isEmpty
          ? "Please Enter a Full Name"
          : nameRegex.hasMatch(name)
              ? ""
              : "Invalid Full Name";
      passwordError = pass.isEmpty
          ? "Please Enter a Password"
          : passwordRegex.hasMatch(pass)
              ? ""
              : "Password must be at least 8 characters and contain at least 1 uppercase letter lowercase letter and number";
      mobileError = phone.isEmpty
          ? "Please Enter a Phone Number"
          : phoneRegex.hasMatch(phone)
              ? ""
              : "Invalid Phone Number";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Set this to true to resize body when keyboard shows
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
          SingleChildScrollView(
            // Wrap your column in a SingleChildScrollView
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom), // Adjust padding dynamically based on the keyboard
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.1), // Dynamic spacing
                  Text(
                    "Sign up",
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontSize: calculateHeightRatio(24, context),
                      fontWeight: AppTextStyles.semibold,
                    ),
                  ),
                  heightSpace(8),
                  Text(
                    "Sign up now and start your journey with us today.",
                    style: GoogleFonts.poppins(
                      color: AppColors.secondary,
                      fontSize: calculateHeightRatio(16, context),
                      fontWeight: AppTextStyles.regular,
                    ),
                  ),
                  heightSpace(7),
                  buildUserDetailsForm(),
                  heightSpace(40),
                  Primarybutton(
                      btntext: "Continue",
                      fontclr: AppColors.primaryText,
                      color: AppColors.primary,
                      width: double.infinity,
                      isLoading: isLoading,
                      ontap: () => performRegister(
                          name: nameController.text,
                          mobile: mobileController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          context: context)),
                  heightSpace(25),
                  buildSignInLink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildInputLabel("Full Name"),
        MyTextField(
          errorName: nameError,
          controller: nameController,
          text: "Your Full Name",
          textInputType: TextInputType.text,
          padding: 6,
        ),
        heightSpace(16),
        buildInputLabel("Mobile"),
        MyTextField(
          errorName: mobileError,
          controller: mobileController,
          text: "Your Mobile",
          textInputType: TextInputType.phone,
          padding: 6,
        ),
        heightSpace(16),
        buildInputLabel("Email"),
        MyTextField(
          errorName: emailError,
          controller: emailController,
          text: "Your Email",
          textInputType: TextInputType.emailAddress,
          padding: 6,
        ),
        heightSpace(16),
        buildInputLabel("Password"),
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
      ],
    );
  }

  Widget buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        color: AppColors.text,
        fontSize: calculateHeightRatio(14, context),
        fontWeight: AppTextStyles.regular,
      ),
    );
  }

  Widget buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Have an account?",
              style: TextStyle(
                color: Colors.grey,
                fontSize: calculateHeightRatio(14, context),
              ),
            ),
            const SizedBox(width: 2),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: Text(
                "Sign in",
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                  fontSize: calculateHeightRatio(13, context),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // Login Fucntion
  Future<void> performRegister({
    required String name,
    required String mobile,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    validation(
      name,
      mobile,
      email,
      password,
    );

    bool check = nameError.isEmpty &&
        passwordError.isEmpty &&
        mobileError.isEmpty &&
        emailError.isEmpty;

    if (check) {
      setState(() => isLoading = true);

      String endpoint = driverRegisterEndPoint;
      final params = {
        "fullName": name,
        "phoneNumber": mobile,
        "email": email,
        "password": password,
      };

      try {
        final response = await NetworkUtil.postData(endpoint, params);
        if (response.isSuccess) {
          // Handle successful login
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OTPScreen(email: email)),
          );
        } else {
          showErrorSnackBar(
              context, response.error?.message ?? "Unknown error occurred");
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
