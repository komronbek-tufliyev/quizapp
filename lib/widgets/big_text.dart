import 'package:flutter/material.dart';
import 'package:quizapp/utilities/dimensions.dart';

class BigText extends StatelessWidget {
  final String text;
  final double size;
  final Color textColor;
  final TextOverflow? textOverflow;
  final int? maxLines;
  const BigText({
    super.key,
    required this.text,
    this.size = 24,
    this.textColor = const Color(0xFFFFFFFF),
    this.textOverflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: TextAlign.justify,
      style: TextStyle(
        overflow: textOverflow,
        fontFamily: "Roboto",
        fontSize: Dimensions.responsiveHeight(size),
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }
}
