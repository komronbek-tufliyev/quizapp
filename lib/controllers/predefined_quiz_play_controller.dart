import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/models/category_model.dart';
import 'package:quizapp/models/predefined_quiz_result_model.dart';
import 'package:quizapp/models/result_model.dart';
import 'package:quizapp/utilities/app_constants.dart';

import '../models/quiz_model.dart';
import '../utilities/app_colors.dart';
import '../utilities/common_ui_functions.dart';

class PredefinedQuizPlayController extends GetxController {
  QuizModel quizModel;
  UserController userController = Get.find<UserController>();
  CategoryModel categoryModel;

  //Contructor
  PredefinedQuizPlayController(
      {required this.quizModel, required this.categoryModel}) {
    initializeQuiz();
  }

  //other variables
  int questionNumber = 0;
  int score = 0;
  List<int> questionCorrectnessTrack = [];
  CountdownTimerController controller = CountdownTimerController(
      endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 5,
      onEnd: () {});
  String question = "";
  String optionA = "";
  String optionB = "";
  String optionC = "";
  String optionD = "";
  String correctOption = "";
  bool isAnswered = false;
  Map<String, Color> optionColorMap = {
    "A": AppColors.mainBlueColor.withOpacity(0.05),
    "B": AppColors.mainBlueColor.withOpacity(0.05),
    "C": AppColors.mainBlueColor.withOpacity(0.05),
    "D": AppColors.mainBlueColor.withOpacity(0.05),
  };
  bool endQuiz = false;

  Future<void> initializeQuiz() async {
    //initializes the correctness to 0 meaning the question has not been answered
    for (int i = 0; i < quizModel.numberOfQuestions; i++) {
      questionCorrectnessTrack.add(0);
    }
  }

  void startQuiz() {
    question = quizModel.quizQuestions[questionNumber].question;
    optionA = quizModel.quizQuestions[questionNumber].optionA;
    optionB = quizModel.quizQuestions[questionNumber].optionB;
    optionC = quizModel.quizQuestions[questionNumber].optionC;
    optionD = quizModel.quizQuestions[questionNumber].optionD;
    correctOption = quizModel.quizQuestions[questionNumber].correctOption;
    controller = CountdownTimerController(
        endTime: DateTime.now().millisecondsSinceEpoch +
            1000 * 60 * quizModel.quizTimeDuration,
        onEnd: () {
          finish();
        });
    update();
  }

  void evaluate(String option) {
    if (option == correctOption.toUpperCase()) {
      score++;
      questionCorrectnessTrack[questionNumber] = 1;
      optionColorMap[option] = Colors.greenAccent;
    } else {
      questionCorrectnessTrack[questionNumber] = -1;
      optionColorMap[option] = Colors.redAccent;
      optionColorMap[correctOption.toUpperCase()] = Colors.greenAccent;
    }
    isAnswered = true;
    update();
  }

  void next() {
    if (isAnswered == true) {
      optionColorMap = {
        "A": AppColors.mainBlueColor.withOpacity(0.05),
        "B": AppColors.mainBlueColor.withOpacity(0.05),
        "C": AppColors.mainBlueColor.withOpacity(0.05),
        "D": AppColors.mainBlueColor.withOpacity(0.05),
      };

      questionNumber++;
      question = quizModel.quizQuestions[questionNumber].question;
      optionA = quizModel.quizQuestions[questionNumber].optionA;
      optionB = quizModel.quizQuestions[questionNumber].optionB;
      optionC = quizModel.quizQuestions[questionNumber].optionC;
      optionD = quizModel.quizQuestions[questionNumber].optionD;
      correctOption = quizModel.quizQuestions[questionNumber].correctOption;
      isAnswered = false;
      update();
    }
  }

  Future<bool> storeResult() async {
    try {
      //storing result of predefined category in user's quizzes
      ResultModel resultModel = ResultModel(
        name: userController.userModel!.name,
        score: score,
        totalScore: quizModel.numberOfQuestions, //each question is of one point
        createdAt: Timestamp.now(),
      );
      await FirebaseFirestore.instance
          .collection(
              'categories/${AppConstants.adminUserId}/${quizModel.quizId}')
          .doc(userController.userModel!.uid)
          .set(resultModel.toJson());
      PredefinedQuizResultModel predefinedQuizResultModel =
          PredefinedQuizResultModel(
        quizName: quizModel.quizName,
        categoryName: categoryModel.name,
        score: score,
        totalScore: quizModel.numberOfQuestions, //each question is of one point
        createdAt: Timestamp.now(),
      );
      await FirebaseFirestore.instance
          .collection('results/${userController.userModel!.uid}/preDefined')
          .doc(quizModel.quizId)
          .set(predefinedQuizResultModel.toJson());
      return true;
    } catch (e) {
      showErrorDialog(description: e.toString());
      return false;
    }
  }

  void finish() async {
    endQuiz = true;
    showProgressIndicatorDialog();
    controller.dispose();
    bool result = await storeResult();
    if (result) {
      Get.back();
    } else {
      showErrorDialog(description: "Something went wrong");
    }
    update();
  }
}
