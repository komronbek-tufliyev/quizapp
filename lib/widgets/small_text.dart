import 'package:flutter/material.dart';
import 'package:quizapp/utilities/dimensions.dart';

class SmallText extends StatelessWidget {
  final String text;
  final double size, lineHeight, wordSpacing;
  final Color textColor;
  final TextAlign textAlign;
  const SmallText({
    super.key,
    required this.text,
    this.size = 16,
    this.textColor = const Color(0xff000000),
    this.textAlign = TextAlign.center,
    this.lineHeight = 1.7,
    this.wordSpacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: "Roboto",
          fontSize: Dimensions.responsiveHeight(size),
          fontWeight: FontWeight.normal,
          color: textColor,
          height: lineHeight,
          wordSpacing: wordSpacing),
    );
  }
}
