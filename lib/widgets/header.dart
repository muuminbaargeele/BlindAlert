import 'package:blind_alert/Helpers/app_colors.dart';
import 'package:blind_alert/Helpers/app_text_style.dart';
import 'package:blind_alert/Helpers/utils.dart';
import 'package:blind_alert/Providers/get_user.dart';
import 'package:blind_alert/Screens/home.dart';
import 'package:blind_alert/Screens/login.dart';
import 'package:blind_alert/models/Driver/driver_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../databases/end_points.dart';
import '../databases/network_utils.dart';
import '../models/Passenger/passenger_model.dart';
import '../models/last_voice_model.dart';

class Header extends StatefulWidget {
  const Header({
    super.key,
    required this.widget,
  });

  final HomeScreen widget;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late PassengerModel passengerModel;
  late DriverModel driverModel;
  late LastVoice lastVoice;
  String? userFullName;
  late Box box;
  late String userId = "";

  Future<void> getUser() async {
    bool isDriver = widget.widget.isDriver;
    final userModelProvider =
        Provider.of<UserModelProvider>(context, listen: false);
    userModelProvider.setLoading(true);
    String endpoint = isDriver ? getDriverEndPoint : getPassengerEndPoint;
    final params = isDriver ? {"email": userId} : {"phoneNumber": userId};
    if (isDriver) {
      try {
        final response = await NetworkUtil.postData(endpoint, params);
        if (response.isSuccess) {
          driverModel = driverModelFromJson(response.payload!.data);
          userModelProvider.setDriverModel(driverModel);
          userFullName = driverModel.fullName;
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

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      box = Hive.box('local_storage');
      userId = box.get("UserId");
      getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModelProvider>(context);
    return Container(
      height: calculateHeightRatio(120, context),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                    "assets/images/${widget.widget.isDriver ? "active_bus.png" : "active_blind.png"}"),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModelProvider.isLoading
                          ? ""
                          : widget.widget.isDriver
                              ? userModelProvider.driverModel.fullName
                              : userModelProvider.passengerModel.fullName,
                      style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: calculateHeightRatio(14, context),
                          fontWeight: AppTextStyles.semibold),
                    ),
                    Text(
                      widget.widget.isDriver ? "Driver" : "Passenger",
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: calculateHeightRatio(12, context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LoginScreen(
                                isDriver: widget.widget.isDriver,
                              )),
                      (Route<dynamic> route) => false);
                },
                child: Image.asset("assets/images/exit.png")),
          ],
        ),
      )),
    );
  }
}
