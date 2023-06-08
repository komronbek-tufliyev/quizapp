import 'package:flutter/material.dart';
import 'package:quizapp/utilities/dimensions.dart';

import '../utilities/app_colors.dart';

class IconContainer extends StatelessWidget {
  final IconData iconData;
  final Color iconColor, containerColor;
  final double iconLeftPadding, iconSize, containerSize;
  const IconContainer(
      {super.key,
      required this.iconData,
      this.iconColor = const Color(0xFFFFFFFF),
      this.containerColor = const Color(0xFF2032FF),
      this.iconLeftPadding = 0,
      this.iconSize = 24,
      this.containerSize = 45});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Dimensions.responsiveHeight(iconLeftPadding),
      ),
      height: Dimensions.responsiveHeight(containerSize),
      width: Dimensions.responsiveHeight(containerSize),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(Dimensions.responsiveHeight(10)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowBlackColor,
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
}
