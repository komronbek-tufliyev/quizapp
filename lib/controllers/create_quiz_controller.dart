import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/utilities/app_colors.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';
import 'package:quizapp/widgets/app_text_field.dart';
import 'package:uuid/uuid.dart';

import '../models/quiz_model.dart';
import '../models/quiz_question_model.dart';
import '../utilities/dimensions.dart';
import '../widgets/big_text.dart';
import '../widgets/small_text.dart';

class CreateQuizController extends GetxController {
  final UserController userController = Get.find();
  QuizModel? quizModel;
  String categoryID = "";
  bool isLastQuestionAdded = false;
  List<QuizQuestionModel> questionList = [];
  bool isLastQuestion = false;
  var questionNumber = 1;
  var questionText = ''.obs;
  var option1 = ''.obs;
  var option2 = ''.obs;
  var option3 = ''.obs;
  var option4 = ''.obs;
  var correctOption = 1.obs;
  RxString quizPassword = 's22w57C'.obs;
  RxString quizId = 's22w57Csafasf'.obs;

  //text editing controllers
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionAController = TextEditingController();
  final TextEditingController optionBController = TextEditingController();
  final TextEditingController optionCController = TextEditingController();
  final TextEditingController optionDController = TextEditingController();
  final TextEditingController correctOptionController = TextEditingController();
  final TextEditingController quizNameController = TextEditingController();
  final TextEditingController numberOfQuestionsController =
      TextEditingController();
  final TextEditingController quizDurationController = TextEditingController();

  int questionCount = 50;
  bool showQuestionAddPage = false;
  Object? dropdownValue;

  //defining errors for text fields
  String? questionError;
  String? optionAError;
  String? optionBError;
  String? optionCError;
  String? optionDError;
  String? correctOptionError;
  String? quizNameError;
  String? categoryError;
  String? numberOfQuestionsError;
  String? quizDurationError;

  CreateQuizController() {
    quizId.value = const Uuid().v4().toString();
  }

  void updateDropdownValue(Object? value) {
    dropdownValue = value;
    update();
  }

  void showQuestionAddPageFunction(bool value) {
    showQuestionAddPage = value;
    update();
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
    if (questionController.text.isEmpty) {
      questionError = "Question cannot be empty";
    } else if (questionController.text.length < 10) {
      questionError = "Question must be at least 10 characters";
    } else {
      questionError = null;
      isQuestionValid = true;
    }

    //validating options A, B, C, D by checking if any of the option match each other or not. No options can be same.
    //validating options A, B, C, D by checking if they are empty
    if (optionAController.text.isEmpty) {
      optionAError = "Option A cannot be empty";
    } else if (optionAController.text == optionBController.text ||
        optionAController.text == optionCController.text ||
        optionAController.text == optionDController.text) {
      optionAError = "Two or more options cannot be same";
    } else {
      optionAError = null;
      isOptionAValid = true;
    }

    if (optionBController.text.isEmpty) {
      optionBError = "Option B cannot be empty";
    } else if (optionBController.text == optionAController.text ||
        optionBController.text == optionCController.text ||
        optionBController.text == optionDController.text) {
      optionBError = "Two or more options cannot be same";
    } else {
      optionBError = null;
      isOptionBValid = true;
    }

    if (optionCController.text.isEmpty) {
      optionCError = "Option C cannot be empty";
    } else if (optionCController.text == optionAController.text ||
        optionCController.text == optionBController.text ||
        optionCController.text == optionDController.text) {
      optionCError = "Two or more options cannot be same";
    } else {
      optionCError = null;
      isOptionCValid = true;
    }

    if (optionDController.text.isEmpty) {
      optionDError = "Option D cannot be empty";
    } else if (optionDController.text == optionAController.text ||
        optionDController.text == optionBController.text ||
        optionDController.text == optionCController.text) {
      optionDError = "Two or more options cannot be same";
    } else {
      optionDError = null;
      isOptionDValid = true;
    }

    areOptionsValid =
        isOptionAValid && isOptionBValid && isOptionCValid && isOptionDValid;

    //validating correct option
    if (correctOptionController.text.isEmpty) {
      correctOptionError = "Correct option cannot be empty";
    } else if (correctOptionController.text.length > 1) {
      correctOptionError = "Correct option must be a single character";
    } else if (correctOptionController.text.toLowerCase() != "a" &&
        correctOptionController.text.toLowerCase() != "b" &&
        correctOptionController.text.toLowerCase() != "c" &&
        correctOptionController.text.toLowerCase() != "d") {
      correctOptionError = "Correct option must be A, B, C or D";
    } else {
      correctOptionError = null;
      isCorrectOptionValid = true;
    }

    if (isQuestionValid && areOptionsValid && isCorrectOptionValid) {
      return true;
    } else {
      update();
      return false;
    }
  }

  bool isQuizDetailsFormValid() {
    bool isQuizNameValid = false;
    bool isNumberOfQuestionsValid = false;
    bool isQuizCategoryValid = false;
    bool isQuizDurationValid = false;
    if (quizNameController.text.isEmpty) {
      quizNameError = "Quiz Name cannot be empty";
    } else if (quizNameController.text.length < 3) {
      quizNameError = "Quiz Name must be at least 3 characters";
    } else {
      quizNameError = null;
      isQuizNameValid = true;
    }

    if (numberOfQuestionsController.text.isEmpty) {
      numberOfQuestionsError = "Number of Questions cannot be empty";
    } else if (int.parse(numberOfQuestionsController.text) < 5 ||
        int.parse(numberOfQuestionsController.text) > 100) {
      numberOfQuestionsError = "Questions must be between 5 and 100";
    } else {
      numberOfQuestionsError = null;
      isNumberOfQuestionsValid = true;
    }

    if (dropdownValue == null) {
      categoryError = "Please select a category";
    } else {
      categoryError = null;
      isQuizCategoryValid = true;
    }

    if (quizDurationController.text.isEmpty) {
      quizDurationError = "Quiz Duration cannot be empty";
    } else if (int.parse(quizDurationController.text) < 1 ||
        int.parse(quizDurationController.text) > 180) {
      quizDurationError = "Quiz Duration must be between 1 and 180";
    } else {
      quizDurationError = null;
      isQuizDurationValid = true;
    }

    if (isQuizNameValid &&
        isNumberOfQuestionsValid &&
        isQuizDurationValid &&
        isQuizCategoryValid) {
      return true;
    } else {
      quizNameError = quizNameError;
      numberOfQuestionsError = numberOfQuestionsError;
      quizDurationError = quizDurationError;
      return false;
    }
  }

  void editPassword() async {
    TextEditingController passwordController = TextEditingController();
    await showDialog(
        context: (Get.context!),
        builder: (context) {
          return Center(
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.height20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const BigText(
                      text: "Edit Password",
                      textColor: AppColors.mainBlueColor,
                      size: 30,
                    ),
                    SizedBox(
                      height: Dimensions.height15,
                    ),
                    const SmallText(
                      text: "Enter new Password",
                      textColor: AppColors.textColor,
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    AppTextField(
                      textEditingController: passwordController,
                      hintText: 'Enter new password',
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const BigText(
                            textColor: Colors.red,
                            text: "Cancel",
                            size: 20,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (passwordController.text.isNotEmpty) {
                              quizPassword.value = passwordController.text;
                              Get.back();
                            } else {
                              showErrorDialog(
                                  description: "Password cannot be empty");
                            }
                          },
                          child: const BigText(
                            text: "Save",
                            textColor: AppColors.mainBlueColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          );
        });
  }

  void createQuizModel() {
    quizModel = QuizModel(
      quizId: quizId.value,
      quizName: quizNameController.text,
      // quizCategoryid: dropdownValue!,
      quizTimeDuration: int.parse(quizDurationController.text),
      quizPassword: quizPassword.value,
      numberOfQuestions: int.parse(numberOfQuestionsController.text),
      quizQuestions: questionList,
      createdAt: Timestamp.now(),
      // questions: questions,
    );
    categoryID = dropdownValue!.toString();
  }

  void createQuizQuestionModelAndAddToList() {
    QuizQuestionModel quizQuestionModel = QuizQuestionModel(
      questionNumber: questionNumber,
      question: questionController.text,
      optionA: optionAController.text,
      optionB: optionBController.text,
      optionC: optionCController.text,
      optionD: optionDController.text,
      correctOption: correctOptionController.text,
    );
    questionList.add(quizQuestionModel);
    update();
  }

  void incrementQuestionNumberAndClearFields() {
    questionNumber++;
    questionController.clear();
    optionAController.clear();
    optionBController.clear();
    optionCController.clear();
    optionDController.clear();
    correctOptionController.clear();
    if (questionNumber == int.parse(numberOfQuestionsController.text)) {
      isLastQuestion = true;
    }
    update();
  }

  void nextQuestion() {
    //! check for form validation after testing
    if (isFormValid()) {
      createQuizQuestionModelAndAddToList();
      incrementQuestionNumberAndClearFields();
    }
  }

  bool addLastQuestion() {
    if (isLastQuestionAdded == false) {
      if (isFormValid()) {
        createQuizQuestionModelAndAddToList();
        isLastQuestionAdded = true;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> finishQuizCreation() async {
    createQuizModel();
    return await addQuizToDatabase();
  }

  Future<bool> addQuizToDatabase() async {
    return await FirebaseCommonFunctions.addDocumentWithNameToCollection(
      collectionReference: FirebaseFirestore.instance.collection(
          "categories/${userController.userModel!.uid}/categoryList/$categoryID/quizList"),
      data: quizModel!.toJson(),
      documentName: quizModel!.quizId,
    );
  }
}
