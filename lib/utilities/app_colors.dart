import 'package:flutter/material.dart';

class AppColors {
  static const Color mainBlueColor = Color(0xFF0023FF);
  static const Color logoBlueColor = Color(0xFF00DBFF);
  static const Color logoBluishWhiteColor = Color(0xFFD7F7FE);
  static const Color lightBlueColor = Color.fromARGB(255, 68, 83, 249);
  static const Color lightestBlueColor = Color.fromARGB(255, 106, 118, 250);

  static const Color fadedBlueColor = Color(0x552032FF);
  static const Color backgroundWhiteColor = Color(0xFFF8F8F8);
  static const Color shadowBlackColor = Color(0x44000000);
  static const Color lowOpacityWhiteColor = Color(0x1FFFFFFF);
  static const Color mediumOpacityWhiteColor = Color(0x6FFFFFFF);
  static const Color titleTextColor = Color(0xFF000000);
  static const Color textColor = Color(0xFF606060);
  static const Color brightCyanColor = Color(0xFF30D6FF);
  static const Color leaderBoardBlueColor = Color(0xFF0091f8);
  static const Color leaderBoardCyanColor = Color(0xFF15d9ff);

  static const List<LinearGradient> homePageGradients = [
    LinearGradient(
      colors: [
        Color(0xFFFF7A46),
        Color(0xFFFA256C),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 4, 205, 236),
        Color(0xFF0023FF),
      ],
    ),
    //green gradient
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(128, 255, 44, 1),
        Color(0xFF058109),
      ],
    ),
  ];

  static const List<Color> gridTextColors = [
    Color(0xFFfd568c),
    Color(0xFF348af3),
    Color(0xFFb745ff),
    Color(0xFF15be9e),
  ];
}
