import 'package:flutter/material.dart';
import 'package:quizapp/utilities/dimensions.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color textColor;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow? textOverflow;
  const CustomText({
    super.key,
    required this.text,
    this.size = 24,
    this.textColor = const Color(0xFFFFFFFF),
    this.fontWeight = FontWeight.normal,
    this.maxLines,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: Dimensions.responsiveHeight(size),
        fontWeight: fontWeight,
        color: textColor,
        overflow: textOverflow,
      ),
    );
  }
}
