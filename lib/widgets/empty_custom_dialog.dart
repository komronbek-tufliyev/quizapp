import 'dart:ui';
import 'package:quizapp/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class EmptyCustomDialog extends StatelessWidget {
  final Widget child;

  const EmptyCustomDialog({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, //to disable back button
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              margin:
                  EdgeInsets.symmetric(horizontal: Dimensions.width40 * 1.25),
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20),
              // height: Dimensions.deviceScreenHeight / 5,
              // width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(Dimensions.height20),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
