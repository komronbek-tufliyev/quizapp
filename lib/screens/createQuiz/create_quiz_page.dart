import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/category_controller.dart';
import 'package:quizapp/utilities/app_colors.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/utilities/dimensions.dart';
import 'package:quizapp/widgets/big_text.dart';
import 'package:quizapp/widgets/custom_text.dart';
import 'package:quizapp/widgets/icon_container.dart';

import '../../controllers/create_quiz_controller.dart';
import '../../routes/route_helper.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/effects/button_press_effect_container.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  //quiz controller
  final CreateQuizController _createQuizController = Get.find();

  //boolean to show the question add page or the quiz detail page

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (_createQuizController.showQuestionAddPage) {
          _createQuizController.isFormValid();
        } else {
          _createQuizController.isQuizDetailsFormValid();
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          bool? exitStatus = await showAlertDialog(
            title: "Confirm?",
            description: "Your all data will be lost",
            buttonText1: "Cancel",
            buttonText2: "Continue",
          );
          return exitStatus;
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundWhiteColor,
          body: Stack(
            children: [
              Container(
                height: Dimensions.responsiveHeight(150) +
                    Dimensions.statusBarHeight,
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
                    //Back button
                    Positioned(
                      top: Dimensions.responsiveHeight(20) +
                          Dimensions.statusBarHeight,
                      left: Dimensions.responsiveWidth(20),
                      child: ButtonPressEffectContainer(
                        onTapFunction: () async {
                          bool? exitStatus = await showAlertDialog(
                            title: "Confirm?",
                            description: "Your all data will be lost",
                            buttonText1: "Cancel",
                            buttonText2: "Continue",
                          );
                          if (exitStatus == true) {
                            Get.back();
                          }
                        },
                        height: Dimensions.height40,
                        width: Dimensions.height40,
                        child: const IconContainer(
                          iconData: Icons.close,
                        ),
                      ),
                    ),
                    //Create Quiz Title
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: Dimensions.responsiveHeight(25) +
                                Dimensions.statusBarHeight),
                        child: const BigText(text: "Create Quiz"),
                      ),
                    ),
                  ],
                ),
              ),
              //Question Box
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: Dimensions.deviceScreenHeight -
                      Dimensions.responsiveHeight(140),
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.responsiveWidth(20), vertical: 20),
                  margin: EdgeInsets.only(
                      left: Dimensions.responsiveWidth(20),
                      right: Dimensions.responsiveWidth(20),
                      bottom: Dimensions.responsiveHeight(20),
                      top: Dimensions.statusBarHeight),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: AppColors.shadowBlackColor,
                            offset: Offset(0, 5),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ]),
                  child: GetBuilder<CreateQuizController>(
                      builder: (createQuizController) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: createQuizController.showQuestionAddPage
                          ? addQuestions()
                          : getQuizDetail(),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.height5),
        CustomText(
          text: "Question ${_createQuizController.questionNumber}",
          fontWeight: FontWeight.w500,
          textColor: Colors.black,
          size: 20,
        ),
        SizedBox(height: Dimensions.height15),
        SizedBox(
          height: Dimensions.height5 * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int index = 0;
                  index <
                      int.parse(_createQuizController
                          .numberOfQuestionsController.text);
                  index++)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: index <=
                                    _createQuizController.questionNumber - 1
                                ? AppColors.mainBlueColor
                                : AppColors.logoBluishWhiteColor,
                          ),
                        ),
                      ),
                      _createQuizController.questionCount >= 50
                          ? const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            )
                          : SizedBox(
                              width: Dimensions.responsiveWidth(3),
                            )
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.height20),
        const BigText(
          text: "Quiz Question",
          textColor: Colors.black,
          size: 16,
        ),
        SizedBox(height: Dimensions.height20),
        AppTextField(
          textEditingController: _createQuizController.questionController,
          hintText: "Your Question Here",
          errorText: _createQuizController.questionError,
        ),
        SizedBox(
          height: Dimensions.height20,
        ),
        const BigText(
          text: "Quiz Answers",
          textColor: Colors.black,
          size: 16,
        ),
        SizedBox(height: Dimensions.height20),
        AppTextField(
          textEditingController: _createQuizController.optionAController,
          hintText: "Option A",
          errorText: _createQuizController.optionAError,
        ),
        SizedBox(height: Dimensions.height15),
        AppTextField(
          textEditingController: _createQuizController.optionBController,
          hintText: "Option B",
          errorText: _createQuizController.optionBError,
        ),
        SizedBox(height: Dimensions.height15),
        AppTextField(
          textEditingController: _createQuizController.optionCController,
          hintText: "Option C",
          errorText: _createQuizController.optionCError,
        ),
        SizedBox(height: Dimensions.height15),
        AppTextField(
          textEditingController: _createQuizController.optionDController,
          hintText: "Option D",
          errorText: _createQuizController.optionDError,
        ),
        SizedBox(
          height: Dimensions.height20,
        ),
        const BigText(
          text: "Correct Option",
          textColor: Colors.black,
          size: 16,
        ),
        SizedBox(height: Dimensions.height20),
        AppTextField(
          textEditingController: _createQuizController.correctOptionController,
          hintText: "A or B or C or D",
          errorText: _createQuizController.correctOptionError,
        ),
        SizedBox(height: Dimensions.height20),
        _createQuizController.isLastQuestion
            ? ButtonPressEffectContainer(
                onTapFunction: () async {
                  bool isQuizValid = _createQuizController.addLastQuestion();
                  if (isQuizValid) {
                    showProgressIndicatorDialog();
                    bool result =
                        await _createQuizController.finishQuizCreation();
                    if (result) {
                      Navigator.of(Get.context!).pop();
                      Get.offNamed(
                        RouteHelper.getQuizCreationSuccessfulPage(
                          quizName: _createQuizController.quizModel!.quizName,
                          quizId: _createQuizController.quizModel!.quizId,
                          passWord:
                              _createQuizController.quizModel!.quizPassword,
                          numberOfQuestions: _createQuizController
                              .quizModel!.numberOfQuestions
                              .toString(),
                        ),
                      );
                      showAppSnackbar(
                          title: "Success",
                          description: "Quiz added to database successfully");
                    } else {
                      showErrorDialog(
                          description:
                              "Some Error Occurred while adding quiz to database. Please try again later");
                    }
                  }
                },
                height: 60,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.mainBlueColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: CustomText(
                    text: "Finish",
                  ),
                ),
              )
            : ButtonPressEffectContainer(
                onTapFunction: () {
                  _createQuizController.nextQuestion();
                },
                height: Dimensions.height60,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.mainBlueColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: CustomText(
                    text: "Continue",
                  ),
                ),
              )
      ],
    );
  }

  Widget getQuizDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.height5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SizedBox(
                height: Dimensions.height60,
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: Dimensions.height10,
                      mainAxisSpacing: Dimensions.height15,
                      childAspectRatio: 6),
                  children: [
                    const BigText(
                      text: "Quiz ID:",
                      textColor: Colors.black,
                      size: 16,
                    ),
                    Obx(
                      () => BigText(
                        text: _createQuizController.quizId.value,
                        textColor: Colors.black,
                        size: 16,
                      ),
                    ),
                    const BigText(
                      text: "Quiz Password:",
                      textColor: Colors.black,
                      size: 16,
                    ),
                    Obx(
                      () => BigText(
                        text: _createQuizController.quizPassword.value,
                        textColor: Colors.black,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonPressEffectContainer(
                  height: Dimensions.height30,
                  width: Dimensions.height30,
                  decoration: BoxDecoration(
                    color: AppColors.logoBluishWhiteColor,
                    borderRadius: BorderRadius.circular(Dimensions.height5),
                  ),
                  onTapFunction: () {
                    Clipboard.setData(ClipboardData(
                        text: _createQuizController.quizId.value));
                    showAppSnackbar(
                        title: "Copied",
                        description:
                            "Quiz ID Copied Successfully to Clipboard");
                  },
                  child: Icon(
                    Icons.copy,
                    size: Dimensions.height10 * 2,
                    color: AppColors.brightCyanColor,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                ButtonPressEffectContainer(
                  height: Dimensions.height30,
                  width: Dimensions.height30,
                  decoration: BoxDecoration(
                    color: AppColors.logoBluishWhiteColor,
                    borderRadius: BorderRadius.circular(Dimensions.height5),
                  ),
                  onTapFunction: () {
                    _createQuizController.editPassword();
                  },
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.brightCyanColor,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: Dimensions.height5),
        const Divider(
          color: Colors.black26,
          thickness: 1,
        ),
        SizedBox(height: Dimensions.height20),
        const BigText(
          text: "Quiz Name",
          textColor: Colors.black,
          size: 16,
        ),
        SizedBox(height: Dimensions.height20),
        AppTextField(
          textEditingController: _createQuizController.quizNameController,
          hintText: "Your Quiz Name Here",
          errorText: _createQuizController.quizNameError,
        ),
        SizedBox(
          height: Dimensions.height20,
        ),
        const BigText(
          text: "Quiz Category",
          textColor: Colors.black,
          size: 16,
        ),
        SizedBox(height: Dimensions.height20),
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.responsiveWidth(20),
                vertical: Dimensions.responsiveHeight(1.5),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textColor,
                  width: 0.2,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowBlackColor,
                    offset: Offset(1, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: GetBuilder<CategoryController>(
                    builder: (categoryController) {
                  return DropdownButton(
                    underline: const SizedBox(
                      height: 0,
                    ),
                    menuMaxHeight: Dimensions.deviceScreenHeight * 0.3,
                    borderRadius: BorderRadius.circular(13),
                    hint: const Text("Select Category"),
                    isExpanded: true,
                    value: _createQuizController.dropdownValue,
                    items: List.generate(
                      categoryController.userDefinedCategoryList.length,
                      (index) => DropdownMenuItem(
                        value: categoryController
                            .userDefinedCategoryList[index].uid,
                        child: Text(categoryController
                            .userDefinedCategoryList[index].name),
                      ),
                    ),
                    onChanged: (value) {
                      _createQuizController.updateDropdownValue(value);
                      _createQuizController.isQuizDetailsFormValid();
                    },
                  );
                }),
              ),
            ),
            _createQuizController.categoryError == null
                ? const SizedBox(
                    height: 0,
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            text: _createQuizController.categoryError!,
                            textColor: Colors.red,
                            size: 15,
                          ),
                        ],
                      ),
                    ],
                  )
          ],
        ),
        SizedBox(
          height: Dimensions.height20,
        ),
        const BigText(
          text: "Number of Questions",
          textColor: Colors.black,
          size: 16,
        ),
        SizedBox(height: Dimensions.height20),
        AppTextField(
          keyboardType: TextInputType.number,
          textEditingController:
              _createQuizController.numberOfQuestionsController,
          hintText: "5-100",
          errorText: _createQuizController.numberOfQuestionsError,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        SizedBox(height: Dimensions.height20),
        const BigText(
          text: "Quiz Duration (in minutes)",
          textColor: Colors.black,
          size: 16,
        ),
        SizedBox(height: Dimensions.height20),
        AppTextField(
          keyboardType: TextInputType.number,
          textEditingController: _createQuizController.quizDurationController,
          hintText: "1-180",
          errorText: _createQuizController.quizDurationError,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        SizedBox(height: Dimensions.height50),
        ButtonPressEffectContainer(
          onTapFunction: () {
            if (_createQuizController.isQuizDetailsFormValid()) {
              _createQuizController.showQuestionAddPageFunction(true);
            }
          },
          height: 60,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColors.mainBlueColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: CustomText(
              text: "Continue",
            ),
          ),
        )
      ],
    );
  }
}
