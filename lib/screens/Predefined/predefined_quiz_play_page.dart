import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:quizapp/models/category_model.dart';
import 'package:quizapp/models/quiz_model.dart';
import '../../controllers/predefined_quiz_play_controller.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/effects/button_press_effect_container.dart';

class PredefinedQuizPlayPage extends StatefulWidget {
  final QuizModel quizModel;
  final CategoryModel categoryModel;

  const PredefinedQuizPlayPage(
      {super.key, required this.quizModel, required this.categoryModel});

  @override
  State<PredefinedQuizPlayPage> createState() => _PredefinedQuizPlayPageState();
}

class _PredefinedQuizPlayPageState extends State<PredefinedQuizPlayPage> {
  late PredefinedQuizPlayController quizPlayController;
  int showPage = 0;

  @override
  void initState() {
    super.initState();
    quizPlayController = Get.put(PredefinedQuizPlayController(
        quizModel: widget.quizModel, categoryModel: widget.categoryModel));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      final bool value = await showDialog(
          barrierColor: Colors.black12,
          context: context,
          builder: (context) {
            return CustomDialog(
              iconData: Icons.exit_to_app,
              title: "Quit",
              descriptionText: "Are you sure to quit?",
              actionWidgets: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const BigText(
                    text: "No",
                    textColor: AppColors.mainBlueColor,
                    size: 20,
                  ),
                ),
                InkWell(
                  onTap: () {
                    quizPlayController.controller.dispose();
                    Navigator.of(context).pop(true);
                  },
                  child: const BigText(
                    text: "Yes",
                    textColor: Colors.red,
                    size: 20,
                  ),
                ),
              ],
            );
          });
      return value;
    }, child: GetBuilder<PredefinedQuizPlayController>(builder: (_) {
      return !quizPlayController.endQuiz
          ? Scaffold(
              body: SizedBox(
                height: double.maxFinite,
                child: Stack(
                  children: [
                    //upperAppBar
                    Container(
                      height: Dimensions.responsiveHeight(200) +
                          Dimensions.statusBarHeight,
                      width: double.maxFinite,
                      decoration:
                          const BoxDecoration(color: AppColors.mainBlueColor),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: Dimensions.responsiveHeight(
                                        showPage == 0 ? 50 : 20) +
                                    Dimensions.statusBarHeight),
                            child: showPage == 0
                                ? const BigText(text: "Play Quiz")
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.width20 * 1.5),
                                    child: Column(
                                      children: [
                                        BigText(
                                          text: quizPlayController
                                              .quizModel.quizName,
                                        ),
                                        SizedBox(
                                          height: Dimensions.height20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GetBuilder<
                                                    PredefinedQuizPlayController>(
                                                builder: (_) {
                                              return BigText(
                                                text:
                                                    "Question ${quizPlayController.questionNumber + 1}",
                                                size: 20,
                                              );
                                            }),
                                            Container(
                                              height: Dimensions.height40,
                                              width: Dimensions.width40 * 3,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(children: [
                                                SizedBox(
                                                    width:
                                                        Dimensions.width15 / 2),
                                                const Icon(Icons.alarm,
                                                    color: Colors.white),
                                                SizedBox(
                                                  width: Dimensions.width15 / 2,
                                                ),
                                                CountdownTimer(
                                                    controller:
                                                        quizPlayController
                                                            .controller,
                                                    widgetBuilder:
                                                        (context, time) {
                                                      if (time == null) {
                                                        return const CustomText(
                                                          text: "00 : 00: 00",
                                                          textColor:
                                                              Colors.white,
                                                          size: 15,
                                                        );
                                                      }
                                                      return CustomText(
                                                        text:
                                                            "${time.hours ?? 00} : ${time.min ?? 00} : ${time.sec ?? 00}",
                                                        textColor: Colors.white,
                                                        size: 15,
                                                      );
                                                    })
                                              ]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimensions.height15,
                                        ),
                                        GetBuilder<
                                                PredefinedQuizPlayController>(
                                            builder: (_) {
                                          return SizedBox(
                                            height: Dimensions.height5 * 0.6,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                for (int index = 0;
                                                    index <
                                                        quizPlayController
                                                            .quizModel
                                                            .numberOfQuestions;
                                                    index++)
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 4,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: quizPlayController
                                                                              .questionCorrectnessTrack[
                                                                          index] ==
                                                                      1
                                                                  ? Colors
                                                                      .greenAccent
                                                                  : quizPlayController.questionCorrectnessTrack[
                                                                              index] ==
                                                                          -1
                                                                      ? Colors
                                                                          .red
                                                                      : AppColors
                                                                          .logoBluishWhiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                        quizPlayController
                                                                    .quizModel
                                                                    .numberOfQuestions >=
                                                                50
                                                            ? const Expanded(
                                                                flex: 1,
                                                                child:
                                                                    SizedBox(),
                                                              )
                                                            : SizedBox(
                                                                width: Dimensions
                                                                    .responsiveWidth(
                                                                        3),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  )),
                      ),
                    ),
                    //Content Box
                    Positioned(
                      top: Dimensions.height60 * 3,
                      left: 0,
                      right: 0,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: Dimensions.deviceScreenHeight * 0.65,
                        ),
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.responsiveWidth(20),
                            vertical: 20),
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.width20),
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
                        child: showPage == 0
                            ? InitialPage()
                            : showPage == 1
                                ? QuizPage()
                                : showPage == 2
                                    ? ResultPage()
                                    : Container(),
                      ),
                    ),
                    Positioned(
                        left: (Dimensions.deviceScreenWidth -
                                Dimensions.width40 * 3) /
                            2,
                        bottom: Dimensions.height30,
                        child: ButtonPressEffectContainer(
                          height: Dimensions.height50,
                          width: Dimensions.width40 * 3,
                          decoration: BoxDecoration(
                            color: AppColors.mainBlueColor.withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(Dimensions.height10),
                          ),
                          child: const CustomText(
                            text: "Exit",
                            textColor: AppColors.mainBlueColor,
                          ),
                          onTapFunction: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    iconData: Icons.exit_to_app,
                                    title: "Quit",
                                    descriptionText:
                                        "You will get 0 points. Are you sure to quit?",
                                    actionWidgets: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const BigText(
                                          text: "No",
                                          textColor: AppColors.mainBlueColor,
                                          size: 20,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          quizPlayController.controller
                                              .dispose();
                                          Get.back();
                                        },
                                        child: const BigText(
                                          text: "Yes",
                                          textColor: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        )),
                  ],
                ),
              ),
            )
          : ResultPage();
    }));
  }

  Widget InitialPage() {
    return Center(
      child: GetBuilder<PredefinedQuizPlayController>(builder: (_) {
        return quizPlayController.quizModel == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    color: AppColors.mainBlueColor,
                  ),
                  BigText(
                      text: "Loading Quiz...",
                      textColor: Colors.black,
                      size: 16),
                ],
              )
            : Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const BigText(
                        text: "Room and Quiz Details",
                        textColor: Colors.black,
                        size: 18,
                      ),
                      SizedBox(height: Dimensions.height20),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.mainBlueColor.withOpacity(0.05),
                          borderRadius:
                              BorderRadius.circular(Dimensions.height15),
                        ),
                        padding: EdgeInsets.all(Dimensions.height15),
                        child: Table(
                          children: [
                            TableRow(children: [
                              const BigText(
                                text: "Room Name",
                                textColor: Colors.black,
                                size: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: Dimensions.height15),
                                child: const CustomText(
                                  text: "Predefined Quiz Room",
                                  textColor: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              const BigText(
                                text: "Category",
                                textColor: Colors.black,
                                size: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: Dimensions.height15),
                                child: CustomText(
                                  text: quizPlayController.categoryModel.name,
                                  textColor: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              const BigText(
                                text: "Quiz Name",
                                textColor: Colors.black,
                                size: 16,
                              ),
                              CustomText(
                                text: quizPlayController.quizModel.quizName,
                                textColor: Colors.black,
                                size: 16,
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ButtonPressEffectContainer(
                      decoration: BoxDecoration(
                        color: AppColors.mainBlueColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onTapFunction: () async {
                        setState(() {
                          showPage = 1;
                        });
                        quizPlayController.startQuiz();
                      },
                      height: Dimensions.height60,
                      width: 0,
                      child: const CustomText(text: "Start Playing"),
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget QuizPage() {
    return GetBuilder<PredefinedQuizPlayController>(builder: (_) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                BigText(
                  text: quizPlayController.question,
                  size: 18,
                  textColor: Colors.black,
                ),
                SizedBox(height: Dimensions.height40),
                GestureDetector(
                  onTap: () {
                    if (quizPlayController.isAnswered == false) {
                      quizPlayController.evaluate("A");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: quizPlayController.optionColorMap["A"],
                      borderRadius: BorderRadius.circular(Dimensions.height15),
                    ),
                    width: double.maxFinite,
                    padding: EdgeInsets.all(Dimensions.height20),
                    child: CustomText(
                      text: quizPlayController.optionA,
                      textColor: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                GestureDetector(
                  onTap: () {
                    if (quizPlayController.isAnswered == false) {
                      quizPlayController.evaluate("B");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: quizPlayController.optionColorMap["B"],
                      borderRadius: BorderRadius.circular(Dimensions.height15),
                    ),
                    width: double.maxFinite,
                    padding: EdgeInsets.all(Dimensions.height20),
                    child: CustomText(
                      text: quizPlayController.optionB,
                      textColor: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                GestureDetector(
                  onTap: () {
                    if (quizPlayController.isAnswered == false) {
                      quizPlayController.evaluate("C");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: quizPlayController.optionColorMap["C"],
                      borderRadius: BorderRadius.circular(Dimensions.height15),
                    ),
                    width: double.maxFinite,
                    padding: EdgeInsets.all(Dimensions.height20),
                    child: CustomText(
                      text: quizPlayController.optionC,
                      textColor: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                GestureDetector(
                  onTap: () {
                    if (quizPlayController.isAnswered == false) {
                      quizPlayController.evaluate("D");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: quizPlayController.optionColorMap["D"],
                      borderRadius: BorderRadius.circular(Dimensions.height15),
                    ),
                    width: double.maxFinite,
                    padding: EdgeInsets.all(Dimensions.height20),
                    child: CustomText(
                      text: quizPlayController.optionD,
                      textColor: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height40),
            ButtonPressEffectContainer(
              decoration: BoxDecoration(
                color: AppColors.mainBlueColor,
                borderRadius: BorderRadius.circular(15),
              ),
              onTapFunction: () {
                (quizPlayController.questionNumber <
                        quizPlayController.quizModel.numberOfQuestions - 1)
                    ? quizPlayController.next()
                    : quizPlayController.finish();
              },
              height: Dimensions.height60,
              width: double.maxFinite,
              child: CustomText(
                  text: (quizPlayController.questionNumber <
                          quizPlayController.quizModel.numberOfQuestions - 1)
                      ? "Next"
                      : "Finish"),
            ),
          ],
        ),
      );
    });
  }

  Widget ResultPage() {
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
                              const CustomText(
                                text: "Completed",
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
                                        text: "Quiz Name",
                                        textColor: AppColors.titleTextColor,
                                        size: 18,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomText(
                                        text: quizPlayController
                                            .quizModel.quizName,
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
                                        text: "Total Points",
                                        textColor: AppColors.titleTextColor,
                                        size: 18,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomText(
                                        text: quizPlayController
                                            .quizModel.numberOfQuestions
                                            .toString(),
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
                                        text: "Your Score",
                                        textColor: AppColors.titleTextColor,
                                        size: 18,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: BigText(
                                        text:
                                            quizPlayController.score.toString(),
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
