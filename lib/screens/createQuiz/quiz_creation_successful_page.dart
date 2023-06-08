import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/utilities/app_colors.dart';
import 'package:quizapp/widgets/big_text.dart';
import 'package:quizapp/widgets/custom_text.dart';
import 'package:quizapp/widgets/effects/button_press_effect_container.dart';
import '../../utilities/dimensions.dart';

class QuizCreationSuccessfulPage extends StatelessWidget {
  final String quizName;
  final String quizId;
  final String passWord;
  final String numberOfQuestions;
  const QuizCreationSuccessfulPage({
    Key? key,
    required this.quizName,
    required this.quizId,
    required this.passWord,
    required this.numberOfQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: AppColors.mainBlueColor,
          image: DecorationImage(
            image: AssetImage("assets/images/glow.png"),
            fit: BoxFit.fill,
            opacity: 0.5,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: Dimensions.developmentDeviceHeight * 0.3,
              left: Dimensions.developmentDeviceWidth * 0.05,
              child: SizedBox(
                height: Dimensions.deviceScreenHeight * 0.7,
                width: Dimensions.deviceScreenWidth * 0.9,
                child: Stack(
                  children: [
                    //? Bottom lightest container
                    Positioned(
                      top: Dimensions.height20 * 2,
                      left: Dimensions.width30 * 2,
                      right: Dimensions.width30 * 2,
                      child: Container(
                        height: Dimensions.deviceScreenHeight * 0.55 +
                            Dimensions.statusBarHeight,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              Dimensions.width20,
                            ),
                            bottomRight: Radius.circular(
                              Dimensions.width20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //? Middle Lighter container
                    Positioned(
                      top: Dimensions.height20,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      child: Container(
                        height: Dimensions.deviceScreenHeight * 0.55 +
                            Dimensions.statusBarHeight,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.lightestBlueColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              Dimensions.width20,
                            ),
                            bottomRight: Radius.circular(
                              Dimensions.width20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //? Top white container
                    Container(
                      height: Dimensions.deviceScreenHeight * 0.55 +
                          Dimensions.statusBarHeight,
                      width: double.maxFinite,
                      padding: EdgeInsets.only(
                        left: Dimensions.deviceScreenWidth * 0.06,
                        right: Dimensions.deviceScreenWidth * 0.06,
                        top: Dimensions.deviceScreenHeight * 0.08,
                        bottom: Dimensions.height20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.width20),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                width: double.maxFinite,
                                height: Dimensions.deviceScreenHeight * 0.07,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/ribbon.png",
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              CustomText(
                                text: quizName,
                                textColor: AppColors.mainBlueColor,
                                fontWeight: FontWeight.w600,
                                size: 27,
                              ),
                              SizedBox(
                                height: Dimensions.height50,
                              ),
                              SizedBox(
                                height: Dimensions.height50,
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: BigText(
                                        text: "Quiz ID",
                                        textColor: AppColors.titleTextColor,
                                        size: 18,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomText(
                                        text: quizId,
                                        textColor: AppColors.mainBlueColor,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              SizedBox(
                                height: Dimensions.height50,
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: BigText(
                                        text: "Password",
                                        textColor: AppColors.titleTextColor,
                                        size: 18,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomText(
                                        text: passWord,
                                        textColor: AppColors.mainBlueColor,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              SizedBox(
                                height: Dimensions.height30,
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: BigText(
                                        text: "Questions",
                                        textColor: AppColors.titleTextColor,
                                        size: 18,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: BigText(
                                        text: numberOfQuestions,
                                        textColor: AppColors.mainBlueColor,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              SizedBox(
                                height: Dimensions.height50,
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ButtonPressEffectContainer(
                              height: Dimensions.height60,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: AppColors.mainBlueColor,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.width20,
                                ),
                              ),
                              onTapFunction: () {
                                Get.back();
                              },
                              child: const BigText(text: "Home"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: Dimensions.developmentDeviceHeight * 0.25,
              left: Dimensions.developmentDeviceWidth * 0.5 -
                  Dimensions.developmentDeviceHeight * 0.05,
              child: Container(
                height: Dimensions.developmentDeviceHeight * 0.1,
                width: Dimensions.developmentDeviceHeight * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    Dimensions.developmentDeviceHeight * 0.06,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.greenAccent[700],
                    size: Dimensions.developmentDeviceHeight * 0.06,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
