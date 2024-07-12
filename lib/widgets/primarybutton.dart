import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blind_alert/Helpers/app_text_style.dart';

class Primarybutton extends StatelessWidget {
  const Primarybutton({
    super.key,
    required this.btntext,
    required this.fontclr,
    required this.color,
    required this.width,
    required this.ontap,
    this.icon,
    this.iconclr,
    this.isLoading,
    this.textSize,
  });

  final String btntext;
  final Color fontclr;
  final Color color;
  final double width;
  final Function() ontap;
  final IconData? icon;
  final Color? iconclr;
  final bool? isLoading;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    double v = MediaQuery.of(context).size.height;
    double h = MediaQuery.of(context).size.width;
    v = h > 400 ? 812 : v;
    h = h > 400 ? 812 : h;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: isLoading ?? false ? null : ontap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: v * 0.0591,
          width: width,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: v * 0.014,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading ?? false
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        btntext,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: fontclr,
                          fontWeight: AppTextStyles.medium,
                          fontSize: textSize ?? v * 0.0197,
                        ),
                      ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: icon != null,
                  child: FaIcon(
                    icon,
                    size: v * 0.023,
                    color: iconclr,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
