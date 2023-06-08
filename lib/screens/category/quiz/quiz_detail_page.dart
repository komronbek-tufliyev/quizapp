import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/quiz_questions_controller.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/models/quiz_question_model.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';
import 'package:quizapp/widgets/page_model.dart';

import '../../../utilities/app_colors.dart';
import '../../../utilities/dimensions.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/effects/button_press_effect_container.dart';
import '../../../widgets/icon_container.dart';

class QuizDetailPage extends StatelessWidget {
  final UserController userController = Get.find();
  final int index;
  final QuizModel quizModel;
  final String categoryId;
  final QuizQuestionsController quizQuestionsController = Get.find();
  QuizDetailPage({
    super.key,
    required this.quizModel,
    required this.categoryId,
    required this.index,
  }) {
    quizQuestionsController.setQuestionModel(quizModel.quizQuestions);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        quizQuestionsController.isChanged
            ? await showAlertDialog(
                    title: "Cancel Edit?",
                    description: "Your edit will not be saved.",
                    buttonText1: "Cancel",
                    buttonText2: "Continue")
                ? Get.back()
                : null
            : Get.back();
        return false;
      },
      child: GetBuilder<QuizQuestionsController>(
          builder: (quizQuestionsController) {
        return Scaffold(
          body: Stack(
            children: [
              PageModel(
                onTapFunction: () async {
                  quizQuestionsController.isChanged
                      ? await showAlertDialog(
                              title: "Cancel Edit?",
                              description: "Your edit will not be saved.",
                              buttonText1: "Cancel",
                              buttonText2: "Continue")
                          ? Get.back()
                          : null
                      : Get.back();
                },
                title: quizModel.quizName,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const IconContainer(
                            iconData: Icons.delete,
                          ),
                          onTap: () {
                            showAlertDialog(
                              title: "Delete?",
                              description:
                                  "Your all questions in this quiz will be deleted",
                              buttonText1: "Cancel",
                              buttonText2: "Continue",
                              onPressed2: () async {
                                Navigator.of(Get.context!).pop();

                                bool success =
                                    await quizQuestionsController.deleteQuiz(
                                        quizID: quizModel.quizId,
                                        categoryID: categoryId);
                                if (success) {
                                  Get.back();
                                  showAppSnackbar(
                                      title: "Success",
                                      description: "Quiz Deleted Successfully");
                                } else {
                                  showErrorDialog(
                                      description:
                                          "This quiz is being used in one or many of your rooms. Please delete that first!");
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        const BigText(
                          text: "Quiz List",
                          textColor: AppColors.titleTextColor,
                        ),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        Expanded(
                            child: ListView.builder(
                          padding: EdgeInsets.all(Dimensions.width20 / 4),
                          physics: const BouncingScrollPhysics(),
                          itemCount: quizModel.numberOfQuestions,
                          itemBuilder: (context, index) {
                            return QuestionWidget(
                              index: index + 1,
                            );
                          },
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              quizQuestionsController.isChanged
                  ? Positioned(
                      top: Dimensions.statusBarHeight + Dimensions.height20,
                      right: Dimensions.width20,
                      child: GestureDetector(
                        onTap: () async {
                          await quizQuestionsController
                              .updateQuestionListToDatabase(
                                  quizId: quizModel.quizId,
                                  categoryUid: categoryId,
                                  index: index);
                        },
                        child: const BigText(
                          text: "Save",
                          size: 18,
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
            ],
          ),
        );
      }),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final int index;
  const QuestionWidget({
    super.key,
    required this.index,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  final TextEditingController _optionCController = TextEditingController();
  final TextEditingController _optionDController = TextEditingController();
  final TextEditingController _correctOptionController =
      TextEditingController();
  bool isEditModeEnabled = false;

  QuizQuestionsController quizQuestionsController = Get.find();
  late QuizQuestionModel quizQuestionModel;

  //init method
  @override
  void initState() {
    super.initState();
    quizQuestionModel = quizQuestionsController.questionList[widget.index - 1];
  }

  void setTextEditingControllers() {
    _questionController.text = quizQuestionModel.question;
    _optionAController.text = quizQuestionModel.optionA;
    _optionBController.text = quizQuestionModel.optionB;
    _optionCController.text = quizQuestionModel.optionC;
    _optionDController.text = quizQuestionModel.optionD;
    _correctOptionController.text = quizQuestionModel.correctOption;
  }

  //errors
  String? questionError;
  String? optionAError;
  String? optionBError;
  String? optionCError;
  String? optionDError;
  String? correctOptionError;

  //dispose all controllers
  @override
  void dispose() {
    _questionController.dispose();
    _optionAController.dispose();
    _optionBController.dispose();
    _optionCController.dispose();
    _optionDController.dispose();
    _correctOptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isEditModeEnabled
        ? Container(
            width: Dimensions.deviceScreenWidth * 0.6,
            margin: EdgeInsets.only(bottom: Dimensions.height30),
            padding: EdgeInsets.all(Dimensions.width20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowBlackColor,
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(Dimensions.height15),
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: BigText(
                          text: "${widget.index}.",
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: BigText(
                          text: quizQuestionModel.question,
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: BigText(
                          text: "A.",
                          textColor: AppColors.textColor,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: BigText(
                          text: quizQuestionModel.optionA,
                          textColor: AppColors.textColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: BigText(
                          text: "B.",
                          textColor: AppColors.textColor,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: BigText(
                          text: quizQuestionModel.optionB,
                          textColor: AppColors.textColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: BigText(
                          text: "C.",
                          textColor: AppColors.textColor,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: BigText(
                          text: quizQuestionModel.optionC,
                          textColor: AppColors.textColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: BigText(
                          text: "D.",
                          textColor: AppColors.textColor,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: BigText(
                          text: quizQuestionModel.optionD,
                          textColor: AppColors.textColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const BigText(
                        text: "Correct Option: ",
                        textColor: AppColors.titleTextColor,
                        size: 18,
                      ),
                      SizedBox(
                        width: Dimensions.width15 / 3 * 2,
                      ),
                      BigText(
                        text: quizQuestionModel.correctOption,
                        textColor: Colors.greenAccent[700]!,
                        size: 22,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonPressEffectContainer(
                              height: Dimensions.height40,
                              width: Dimensions.height40,
                              decoration: BoxDecoration(
                                  color: AppColors.mainBlueColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.height10)),
                              onTapFunction: () {
                                setTextEditingControllers();
                                setState(() {
                                  isEditModeEnabled = true;
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: Dimensions.height25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: Dimensions.deviceScreenWidth * 0.6,
              margin: EdgeInsets.only(bottom: Dimensions.height30),
              padding: EdgeInsets.all(Dimensions.width20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowBlackColor,
                    offset: Offset(1, 1),
                    blurRadius: 1,
                    spreadRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.circular(Dimensions.height15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        text: "Question ${widget.index}",
                        textColor: AppColors.titleTextColor,
                        size: 18,
                      ),
                      ButtonPressEffectContainer(
                        height: Dimensions.height40,
                        width: Dimensions.height40,
                        decoration: BoxDecoration(
                            color: AppColors.mainBlueColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.height10)),
                        onTapFunction: () {
                          if (isFormValid()) {
                            quizQuestionsController.setChanged(true);
                            setState(() {
                              isEditModeEnabled = false;
                            });
                            quizQuestionModel = QuizQuestionModel(
                              question: _questionController.text,
                              optionA: _optionAController.text,
                              optionB: _optionBController.text,
                              optionC: _optionCController.text,
                              optionD: _optionDController.text,
                              correctOption: _correctOptionController.text,
                              questionNumber: quizQuestionModel.questionNumber,
                            );
                            quizQuestionsController.updateQuestionList(
                                index: widget.index - 1,
                                quizQuestionModel: quizQuestionModel);
                          }
                        },
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: Dimensions.height25,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  AppTextField(
                    textEditingController: _questionController,
                    hintText: "Your Question Here",
                    errorText: questionError,
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
                    textEditingController: _optionAController,
                    hintText: "Option A",
                    errorText: optionAError,
                  ),
                  SizedBox(height: Dimensions.height15),
                  AppTextField(
                    textEditingController: _optionBController,
                    hintText: "Option B",
                    errorText: optionBError,
                  ),
                  SizedBox(height: Dimensions.height15),
                  AppTextField(
                    textEditingController: _optionCController,
                    hintText: "Option C",
                    errorText: optionCError,
                  ),
                  SizedBox(height: Dimensions.height15),
                  AppTextField(
                    textEditingController: _optionDController,
                    hintText: "Option D",
                    errorText: optionDError,
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
                    textEditingController: _correctOptionController,
                    hintText: "A or B or C or D",
                    errorText: correctOptionError,
                  ),
                  SizedBox(height: Dimensions.height20),
                ],
              ),
            ),
          );
  }

  bool isFormValid() {
    bool isQuestionValid = false;
    bool isOptionAValid = false;
    bool isOptionBValid = false;
    bool isOptionCValid = false;
    bool isOptionDValid = false;
    bool areOptionsValid = false;
    bool isCorrectOptionValid = false;

    //validating question
    if (_questionController.text.isEmpty) {
      questionError = "Question cannot be empty";
    } else if (_questionController.text.length <= 10) {
      questionError = "Question must be at least 10 characters";
    } else {
      questionError = null;
      isQuestionValid = true;
    }

    //validating options A, B, C, D by checking if any of the option match each other or not. No options can be same.
    //validating options A, B, C, D by checking if they are empty
    if (_optionAController.text.isEmpty) {
      optionAError = "Option A cannot be empty";
    } else if (_optionAController.text == _optionBController.text ||
        _optionAController.text == _optionCController.text ||
        _optionAController.text == _optionDController.text) {
      optionAError = "Two or more options cannot be same";
    } else {
      optionAError = null;
      isOptionAValid = true;
    }

    if (_optionBController.text.isEmpty) {
      optionBError = "Option B cannot be empty";
    } else if (_optionBController.text == _optionAController.text ||
        _optionBController.text == _optionCController.text ||
        _optionBController.text == _optionDController.text) {
      optionBError = "Two or more options cannot be same";
    } else {
      optionBError = null;
      isOptionBValid = true;
    }

    if (_optionCController.text.isEmpty) {
      optionCError = "Option C cannot be empty";
    } else if (_optionCController.text == _optionAController.text ||
        _optionCController.text == _optionBController.text ||
        _optionCController.text == _optionDController.text) {
      optionCError = "Two or more options cannot be same";
    } else {
      optionCError = null;
      isOptionCValid = true;
    }

    if (_optionDController.text.isEmpty) {
      optionDError = "Option D cannot be empty";
    } else if (_optionDController.text == _optionAController.text ||
        _optionDController.text == _optionBController.text ||
        _optionDController.text == _optionCController.text) {
      optionDError = "Two or more options cannot be same";
    } else {
      optionDError = null;
      isOptionDValid = true;
    }

    areOptionsValid =
        isOptionAValid && isOptionBValid && isOptionCValid && isOptionDValid;

    //validating correct option
    if (_correctOptionController.text.isEmpty) {
      correctOptionError = "Correct option cannot be empty";
    } else if (_correctOptionController.text.length > 1) {
      correctOptionError = "Correct option must be a single character";
    } else if (_correctOptionController.text.toLowerCase() != "a" &&
        _correctOptionController.text.toLowerCase() != "b" &&
        _correctOptionController.text.toLowerCase() != "c" &&
        _correctOptionController.text.toLowerCase() != "d") {
      correctOptionError = "Correct option must be A, B, C or D";
    } else {
      correctOptionError = null;
      isCorrectOptionValid = true;
    }

    if (isQuestionValid && areOptionsValid && isCorrectOptionValid) {
      return true;
    } else {
      setState(() {
        questionError = questionError;
        optionAError = optionAError;
        optionBError = optionBError;
        optionCError = optionCError;
        optionDError = optionDError;
        correctOptionError = correctOptionError;
      });
      return false;
    }
  }
}
