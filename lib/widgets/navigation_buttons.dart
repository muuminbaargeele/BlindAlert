import 'package:blind_alert/Helpers/utils.dart';
import 'package:flutter/material.dart';

import '../Helpers/app_colors.dart';
import '../Helpers/app_text_style.dart';

class NavigationButtons extends StatefulWidget {
  const NavigationButtons({super.key, required this.isVoicePage, required this.ontap, required this.image, required this.text});

  final bool isVoicePage;
  final VoidCallback ontap;
  final String image;
  final String text;

  @override
  State<NavigationButtons> createState() => _NavigationButtonsState();
}

class _NavigationButtonsState extends State<NavigationButtons> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: widget.ontap,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 47),
                        child: Container(
                          height: calculateHeightRatio(40, context),
                          decoration: BoxDecoration(
                              color: widget.isVoicePage ? AppColors.primary : Colors.transparent ,
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: widget.isVoicePage ? 12 : 8, horizontal: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    widget.image),
                                widthSpace(2),
                                Visibility(
                                    visible: widget.isVoicePage,
                                    child: Text(
                                      widget.text,
                                      style: TextStyle(
                                          color: AppColors.primaryText,
                                          fontSize:
                                              calculateHeightRatio(8, context),
                                          fontWeight: AppTextStyles.semibold),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
  }
}