import 'dart:ui';
import 'package:quizapp/utilities/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/widgets/big_text.dart';
import 'package:quizapp/widgets/small_text.dart';

class CustomDialog extends StatelessWidget {
  final String title, descriptionText;
  final List<Widget> actionWidgets;
  final IconData iconData;
  final Color iconColor, titleColor, textColor;
  const CustomDialog({
    super.key,
    required this.title,
    required this.descriptionText,
    this.iconData = Icons.exit_to_app,
    this.actionWidgets = const [],
    this.iconColor = const Color(0xFF0023FF),
    this.titleColor = const Color(0xFF0023FF),
    this.textColor = const Color(0xFF000000),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.width40 * 1.25),
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height20),
          // height: Dimensions.deviceScreenHeight / 5,
          // width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(Dimensions.height20),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                iconData,
                color: iconColor,
              ),
              BigText(
                text: title,
                textColor: titleColor,
                size: 30,
              ),
              SizedBox(
                height: Dimensions.height15,
              ),
              SmallText(
                text: descriptionText,
                textColor: textColor,
              ),
              SizedBox(
                height: Dimensions.height30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: actionWidgets,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
