import 'package:flutter/material.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_container.dart';

class PageModel extends StatelessWidget {
  final Function()? onTapFunction;
  final String title;
  final Widget child;
  const PageModel({
    super.key,
    this.onTapFunction,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        child: Stack(
          children: [
            //upperAppBar
            Container(
              height:
                  Dimensions.responsiveHeight(150) + Dimensions.statusBarHeight,
              width: double.maxFinite,
              decoration: const BoxDecoration(color: AppColors.mainBlueColor),
              child: Stack(
                children: [
                  //Left Small Circle Design
                  Positioned(
                    top: Dimensions.responsiveHeight(50) +
                        Dimensions.statusBarHeight,
                    left: Dimensions.responsiveWidth(70),
                    child: CircleAvatar(
                      backgroundColor: AppColors.lowOpacityWhiteColor,
                      radius: Dimensions.responsiveHeight(40),
                    ),
                  ),
                  //Right Large Circle Design
                  Positioned(
                    top: Dimensions.responsiveHeight(-20),
                    right: Dimensions.responsiveWidth(-30),
                    child: CircleAvatar(
                      backgroundColor: AppColors.lowOpacityWhiteColor,
                      radius: Dimensions.responsiveHeight(90),
                    ),
                  ),
                  //Create Quiz Title
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.responsiveHeight(25) +
                              Dimensions.statusBarHeight),
                      child: BigText(text: title),
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                      top: Dimensions.statusBarHeight + Dimensions.height10,
                      right: Dimensions.width30,
                      left: Dimensions.width30,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onTapFunction,
                          child: const IconContainer(
                            iconData: Icons.arrow_back_ios,
                            iconLeftPadding: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Content Box
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimensions.deviceScreenHeight * 0.80,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.responsiveWidth(20),
                    vertical: Dimensions.height30),
                margin: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height50),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowBlackColor,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        spreadRadius: 2,
                      ),
                    ]),
                child: child,
              ),
            )
          ],
        ),
      ),
    );
  }
}
