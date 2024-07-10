import 'package:blind_alert/app_colors.dart';
import 'package:flutter/material.dart';

class IsDriverButtons extends StatelessWidget {
  const IsDriverButtons(
      {super.key,
      required this.isDriver,
      required this.ontap,
      required this.image});

  final bool isDriver;
  final VoidCallback ontap;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: isDriver ? Colors.transparent : AppColors.primary,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: ontap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: isDriver ? AppColors.primary : Colors.transparent,
                    width: 2),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(image),
            ),
          ),
        ),
      ),
    );
  }
}
