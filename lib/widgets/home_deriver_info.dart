import 'package:flutter/material.dart';

import '../Helpers/app_colors.dart';
import '../Helpers/app_text_style.dart';
import '../Helpers/utils.dart';
import '../Providers/get_user.dart';
import 'driver_info.dart';

class HomeDriverInfo extends StatelessWidget {
  const HomeDriverInfo({
    super.key,
    required this.userModelProvider,
  });

  final UserModelProvider userModelProvider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
      child: Column(
        children: [
          SizedBox(
              height: calculateHeightRatio(100, context),
              child: Image.asset("assets/images/in_active_bus.png")),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: [
                Text(
                  "Full Name:",
                  style: TextStyle(
                    color: AppColors.text.withOpacity(0.5),
                    fontSize: calculateHeightRatio(16, context),
                    fontWeight: AppTextStyles.light,
                  ),
                ),
                widthSpace(5),
                Text(
                  userModelProvider.isLoading
                      ? ""
                      : userModelProvider.passengerModel.driverName,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: calculateHeightRatio(16, context),
                    fontWeight: AppTextStyles.semibold,
                  ),
                )
              ],
            ),
          ),
          const DriverInfo(
            title: "Title",
            body: "Driver",
          ),
          DriverInfo(
            title: "Phone Number:",
            body: userModelProvider.passengerModel.driverPhoneNumber,
          ),
          DriverInfo(
            title: "Email:",
            body: userModelProvider.passengerModel.driverEmail,
          ),
        ],
      ),
    ));
  }
}