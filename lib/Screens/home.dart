import 'package:blind_alert/Screens/login.dart';
import 'package:blind_alert/app_colors.dart';
import 'package:blind_alert/app_text_style.dart';
import 'package:blind_alert/utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.isDriver, this.mobile, this.email});

  final bool isDriver;
  final String? mobile;
  final String? email;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      "assets/images/${widget.isDriver ? "active_bus.png" : "active_blind.png"}"),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ahmed Khalif Muumin",
                        style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: calculateHeightRatio(14, context),
                            fontWeight: AppTextStyles.semibold),
                      ),
                      Text(
                        widget.isDriver ? "Driver" : "Passenger",
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
                                  isDriver: widget.isDriver,
                                )),
                        (Route<dynamic> route) => false);
                  },
                  child: Image.asset("assets/images/exit.png")),
            ],
          ),
        )),
      ),
    );
  }
}
