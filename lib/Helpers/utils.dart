import 'package:flutter/material.dart';

// Function to calculate the height ratio
double calculateHeightRatio(double itemHeight, BuildContext context) {
  const referenceScreenHeight = 812.0; // Your reference screen height
  double screenHeight =
      MediaQuery.of(context).size.height; // Actual screen height
  return (itemHeight / referenceScreenHeight) * screenHeight;
}

Widget heightSpace(double size) {
  return SizedBox(
    height: size,
  );
}
Widget widthSpace(double size) {
  return SizedBox(
    width: size,
  );
}
