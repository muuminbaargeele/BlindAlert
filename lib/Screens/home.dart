import 'package:blind_alert/Helpers/app_colors.dart';
import 'package:blind_alert/Helpers/utils.dart';
import 'package:blind_alert/Providers/get_user.dart';
import 'package:blind_alert/widgets/header.dart';
import 'package:blind_alert/widgets/navigation_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../Helpers/app_text_style.dart';
import '../Providers/last_voice.dart';
import '../databases/end_points.dart';
import '../databases/network_utils.dart';
import '../models/Driver/driver_model.dart';
import '../models/Passenger/passenger_model.dart';
import '../models/last_voice_model.dart';
import '../widgets/home_deriver_info.dart';
import '../widgets/home_voice_content.dart';
import '../widgets/mytextfield.dart';
import '../widgets/primarybutton.dart';
import '../widgets/recorder.dart';

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
  bool isAuduoPage = true;
  bool isLoading = false;

  String nameError = "";
  TextEditingController nameController = TextEditingController();
  String mobileError = "";
  TextEditingController mobileController = TextEditingController();
  String locationError = "";
  TextEditingController locationController = TextEditingController();

  String? driverEmail;
  String? userId;

  late PassengerModel passengerModel;
  late DriverModel driverModel;
  late LastVoice lastVoice;

  void updateIsAudioPage(state) {
    setState(() {
      isAuduoPage = state;
    });
  }

  Future<void> getUser() async {
    bool isDriver = widget.isDriver;
    final userModelProvider =
        Provider.of<UserModelProvider>(context, listen: false);
    userModelProvider.setLoading(true);
    String endpoint = isDriver ? getDriverEndPoint : getPassengerEndPoint;
    final params = isDriver ? {"email": userId} : {"phoneNumber": userId};
    if (isDriver) {
      try {
        final response = await NetworkUtil.postData(endpoint, params);
        if (response.isSuccess) {
          print(response.payload!.data);
          driverModel = driverModelFromJson(response.payload!.data);
          userModelProvider.setDriverModel(driverModel);
          userModelProvider.setLoading(false);
        } else {
          showErrorSnackBar(
              context, response.error?.message ?? "Unknown error occurred");
          userModelProvider.setLoading(true);
        }
      } catch (e) {
        print("$e");
        showErrorSnackBar(context, "Failed to connect. Check your network.");
        userModelProvider.setLoading(true);
      }
    } else {
      try {
        final response = await NetworkUtil.postData(endpoint, params);
        if (response.isSuccess) {
          passengerModel = passengerModelFromJson(response.payload!.data);
          userModelProvider.setPassengerModel(passengerModel);
          userModelProvider.setLoading(false);
        } else {
          showErrorSnackBar(
              context, response.error?.message ?? "Unknown error occurred");
          userModelProvider.setLoading(true);
        }
      } catch (e) {
        print("$e");
        showErrorSnackBar(context, "Failed to connect. Check your network.");
        userModelProvider.setLoading(true);
      }
    }
    // getUser();
  }

  Future<void> getVoice(String driverEmail) async {
    final lastVoiceModelProvider =
        Provider.of<LastVoiceModelProvider>(context, listen: false);
    lastVoiceModelProvider.setLoading(true);
    final params = {"email": driverEmail};
    print(params);
    try {
      final response = await NetworkUtil.postData(getLastVoiceEndPoint, params);
      if (response.isSuccess) {
        lastVoice = lastVoiceFromJson(response.payload!.data);
        lastVoiceModelProvider.setLastVoiceModel(lastVoice);
        lastVoiceModelProvider.setLoading(false);
      } else {
        showErrorSnackBar(
            context, response.error?.message ?? "Unknown error occurred");
        lastVoiceModelProvider.setLoading(true);
      }
    } catch (e) {
      print("$e");
      showErrorSnackBar(context, "Failed to connect. Check your network.");
      lastVoiceModelProvider.setLoading(true);
    }
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  void initState() {
    super.initState();
    late Box box;
    box = Hive.box('local_storage');
    driverEmail = box.get('UserId');
    userId = driverEmail;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUser();
      getVoice(driverEmail!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModelProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Header(
            widget: widget,
          ),
          isAuduoPage
              ? isVoicePage
                  ? HomeVoiceContent(
                      isAuduoPage: isAuduoPage,
                      updateIsAudioPage: updateIsAudioPage,
                    )
                  : HomeDriverInfo(userModelProvider: userModelProvider)
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => updateIsAudioPage(true),
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
                            onTap: () => updateIsAudioPage(false),
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
                    buildUserDetailsForm(),
                    heightSpace(40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Primarybutton(
                          btntext: "register",
                          fontclr: AppColors.primaryText,
                          color: AppColors.primary,
                          width: double.infinity,
                          isLoading: isLoading,
                          ontap: () => performRegister(
                              name: nameController.text,
                              mobile: mobileController.text,
                              location: locationController.text,
                              context: context)),
                    ),
                  ],
                ),
          widget.isDriver
              ? Visibility(
                  visible: isAuduoPage,
                  child: Recorder(),
                )
              : Container(
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

  Widget buildUserDetailsForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildInputLabel("Full Name"),
          MyTextField(
            errorName: nameError,
            controller: nameController,
            text: "Passenger Full Name",
            textInputType: TextInputType.text,
            padding: 6,
          ),
          heightSpace(16),
          buildInputLabel("Mobile"),
          MyTextField(
            errorName: mobileError,
            controller: mobileController,
            text: "Passenger Mobile",
            textInputType: TextInputType.phone,
            padding: 6,
          ),
          heightSpace(16),
          buildInputLabel("Locaion"),
          MyTextField(
            errorName: locationError,
            controller: locationController,
            text: "Passenger Location",
            textInputType: TextInputType.streetAddress,
            padding: 6,
          ),
        ],
      ),
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

  // Login Fucntion
  Future<void> performRegister({
    required String name,
    required String mobile,
    required String location,
    required BuildContext context,
  }) async {
    validation(
      name,
      mobile,
      location,
    );

    bool check =
        nameError.isEmpty && locationError.isEmpty && mobileError.isEmpty;

    if (check) {
      setState(() => isLoading = true);

      String endpoint = passengerRegisterEndPoint;
      final params = {
        "fullName": name,
        "phoneNumber": mobile,
        "location": location,
        "driverEmail": driverEmail
      };

      try {
        final response = await NetworkUtil.postData(endpoint, params);
        if (response.isSuccess) {
          // Handle successful login
          setState(() {
            nameController.text = "";
            mobileController.text = "";
            locationController.text = "";
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Passenger Register Successfully"),
              backgroundColor: Colors.green,
            ),
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

  validation(
    name,
    phone,
    location,
  ) {
    final RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
    final RegExp phoneRegex = RegExp(r"^[6]\d{8}$");

    setState(() {
      nameError = name.isEmpty
          ? "Please Enter a Passenger name"
          : nameRegex.hasMatch(name)
              ? ""
              : "Invalid Full Name";
      locationError = location.isEmpty
          ? "Please Enter a Location"
          : nameRegex.hasMatch(location)
              ? ""
              : "Invalid Location";
      mobileError = phone.isEmpty
          ? "Please Enter a Phone Number"
          : phoneRegex.hasMatch(phone)
              ? ""
              : "Invalid Phone Number";
    });
  }
}
