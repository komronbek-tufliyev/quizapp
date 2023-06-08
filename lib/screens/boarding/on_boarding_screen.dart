import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/widgets/exit_enabled_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/route_helper.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/app_constants.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/effects/bounce_back_forth_image.dart';
import '../../widgets/effects/button_press_effect_container.dart';
import '../../widgets/icon_container.dart';
import '../../widgets/small_text.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
  double currentPageValue = 0;
  int lastPageIndex = 2;

  //for pageview item layout
  double containerTopPadding = Dimensions.statusBarHeight;
  double firstSizedBoxHeight = Dimensions.height50;
  double secondSizedBoxHeight = Dimensions.height20;
  double containerHeight = Dimensions.deviceScreenHeight / 2;
  double bigTextSize = Dimensions.responsiveHeight(27);
  double smallTextContainerSize = Dimensions.deviceScreenHeight / 5;

  //List of title description for each page of the landing Screen
  final List<String> titleText = [
    "Create your own game",
    "Challenge your friends",
    "Watch Leaderboard",
  ];

//List of text description for each page of the landing Screen
  final List<String> descriptionText = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut arcu orci, fermentum et nisi nec, facilisis molestie tortor. Vivamus eu augue ac elit ullamcorper efficitur placerat a dolor.",
    "consectetur adipiscing elit. Ut arcu orci, fermentum et nisi nec, facilisis molestie tortor. Vivamus eu augue ac elit ullamcorper efficitur placerat a dolor.",
    "dolor sit amet, consectetur adipiscing elit. Ut arcu orci, fermentum et nisi nec, facilisis molestie tortor. Vivamus eu augue ac elit ullamcorper efficitur placerat."
  ];

//list of image path for each image on the image screen
  final List<String> images = [
    "assets/images/createQuiz.png",
    "assets/images/challengeFriends.png",
    "assets/images/leaderboard.png",
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page!;
      });
    });
  }

  //disposing page controller
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void getStarted() {
    sharedPreferences.setBool(AppConstants.firstLoad, false);
    Get.offNamed(RouteHelper.getSignUpPage());
  }

  Widget _pageViewItem(int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        //upper blue background container
        Container(
          padding: EdgeInsets.only(top: Dimensions.statusBarHeight),
          height: containerHeight,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          //stack for circle and image to overlap
          child: Stack(
            children: [
              //image
              Center(
                //AnimatedBuilder for swipe animation
                child: BounceBackForthImage(
                  yPos: 10,
                  xPos: 0,
                  yNeg: 10,
                  xNeg: 0,
                  duration: const Duration(seconds: 4),
                  path: images[index],
                  imageHeight: Dimensions.height130 * 2.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: firstSizedBoxHeight - Dimensions.height10),
        //title text
        BigText(
          text: titleText[index],
          textColor: AppColors.titleTextColor,
          size: bigTextSize,
        ),
        SizedBox(height: secondSizedBoxHeight),
        //description text
        Container(
          height: smallTextContainerSize,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width40),
          child: SmallText(
            text: descriptionText[index],
            textColor: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExitEnabledWidget(
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhiteColor,
        body: Stack(
          children: [
            Column(
              children: [
                //upper blue background container
                Container(
                  padding: EdgeInsets.only(top: Dimensions.statusBarHeight),
                  height: Dimensions.deviceScreenHeight / 2,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.mainBlueColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimensions.height50),
                      bottomRight: Radius.circular(Dimensions.height50),
                    ),
                  ),
                  //stack for circle and image to overlap
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: Dimensions.height30),
                      child: CircleAvatar(
                        radius:
                            Dimensions.responsiveHeight(Dimensions.height130),
                        backgroundColor: AppColors.mediumOpacityWhiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: firstSizedBoxHeight +
                      secondSizedBoxHeight +
                      containerHeight +
                      smallTextContainerSize +
                      containerTopPadding +
                      Dimensions.responsiveHeight(bigTextSize),
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return _pageViewItem(index);
                      }),
                ),
                SizedBox(height: Dimensions.height10),
                //to provide set of values to dots indicator for smooth dots animation.
                DotsIndicator(
                  dotsCount: 3,
                  position: currentPageValue,
                  decorator: DotsDecorator(
                    activeColor: AppColors.mainBlueColor,
                    activeSize: const Size(22, 9),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(
            bottom: Dimensions.height30,
            left: Dimensions.width20,
            right: Dimensions.width20,
          ),
          //skip and next button
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //removing skip button in last page
              currentPageValue.floor() != lastPageIndex
                  //skip button
                  ? InkWell(
                      onTap: () {
                        getStarted();
                      },
                      splashColor: AppColors.mainBlueColor.withOpacity(0.2),
                      child: const SmallText(
                        text: "Skip",
                        textColor: AppColors.textColor,
                        size: 20,
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                    ),
              //Next button is shown only if the page is not lastpage of landing screen and also if the getting started container has animated back to its original size.
              currentPageValue.floor() != lastPageIndex
                  ? ButtonPressEffectContainer(
                      onTapFunction: () async {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      },
                      height: Dimensions.height60,
                      width: Dimensions.height60,
                      child: IconContainer(
                        containerColor: AppColors.mainBlueColor,
                        iconData: Icons.arrow_forward_ios,
                        containerSize: Dimensions.height60,
                      ),
                    )
                  //to animate get started contianer size.
                  : TweenAnimationBuilder(
                      tween: Tween<double>(begin: 1, end: 2.5),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return ButtonPressEffectContainer(
                          key: UniqueKey(),
                          height: Dimensions.height60,
                          width: Dimensions.height60 * value,
                          decoration: BoxDecoration(
                            color: AppColors.mainBlueColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.height15),
                          ),
                          onTapFunction: () {
                            getStarted();
                          },
                          child: Center(
                            child: IgnorePointer(
                              child: AnimatedTextKit(
                                totalRepeatCount: 1,
                                pause: const Duration(
                                  milliseconds: 500,
                                ),
                                animatedTexts: [
                                  TyperAnimatedText(
                                    "Get Started",
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
