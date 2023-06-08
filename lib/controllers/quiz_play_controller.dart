import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/models/room_model.dart';
import 'package:quizapp/models/userDefined_quiz_result_model.dart';
import 'package:quizapp/utilities/app_colors.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';

import '../models/result_model.dart';

class QuizPlayController extends GetxController {
  UserController userController = Get.find<UserController>();
  final RoomModel roomModel;
  QuizModel? quizModel;
  int questionNumber = 0;
  int score = 0;
  List<int> questionCorrectnessTrack = [];
  late CountdownTimerController controller;
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

  QuizPlayController({required this.roomModel}) {
    getQuiz();
  }

  @override
  void dispose() {
    controller.disposeTimer();
    super.dispose();
  }

  Future<void> getQuiz() async {
    await FirebaseCommonFunctions.getDocumentFromCollection(
            collectionReference: FirebaseFirestore.instance.collection(
                "categories/${roomModel.ownerId}/categoryList/${roomModel.categoryId}/quizList"),
            documentId: roomModel.quizId)
        .then((value) {
      if (value != null) {
        quizModel = QuizModel.fromJson(value.data() as Map<String, dynamic>);
      }
    });

    if (quizModel != null) {
      update();
    }
    //initializes the correctness to 0 meaning the question has not been answered
    for (int i = 0; i < quizModel!.numberOfQuestions; i++) {
      questionCorrectnessTrack.add(0);
    }

    // controller = CountdownTimerController(
    //     endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 5,
    //     onEnd: onEnd);
  }

  Future<bool> checkIfTheUserHasAlreadyPlayed() async {
    bool result = await FirebaseCommonFunctions.checkIfDocumentExists(
        FirebaseFirestore.instance
            .collection("rooms/${roomModel.roomId}/results"),
        userController.userModel!.uid);
    return result;
  }

  Future<bool> setInitialPlayedUserScoreToZero() async {
    bool result = await storeResult();
    return result;
  }

  void startQuiz() {
    question = quizModel!.quizQuestions[questionNumber].question;
    optionA = quizModel!.quizQuestions[questionNumber].optionA;
    optionB = quizModel!.quizQuestions[questionNumber].optionB;
    optionC = quizModel!.quizQuestions[questionNumber].optionC;
    optionD = quizModel!.quizQuestions[questionNumber].optionD;
    correctOption = quizModel!.quizQuestions[questionNumber].correctOption;
    controller = CountdownTimerController(
        endTime: DateTime.now().millisecondsSinceEpoch +
            1000 * 60 * quizModel!.quizTimeDuration,
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
      question = quizModel!.quizQuestions[questionNumber].question;
      optionA = quizModel!.quizQuestions[questionNumber].optionA;
      optionB = quizModel!.quizQuestions[questionNumber].optionB;
      optionC = quizModel!.quizQuestions[questionNumber].optionC;
      optionD = quizModel!.quizQuestions[questionNumber].optionD;
      correctOption = quizModel!.quizQuestions[questionNumber].correctOption;
      isAnswered = false;
      update();
    }
  }

  Future<bool> storeResult() async {
    try {
      ResultModel resultModel = ResultModel(
        name: userController.userModel!.name,
        score: score,
        totalScore:
            quizModel!.numberOfQuestions, //each question is of one point
        createdAt: Timestamp.now(),
      );
      await FirebaseFirestore.instance
          .collection('rooms/${roomModel.roomId}/results')
          .doc(userController.userModel!.uid)
          .set(resultModel.toJson());
      UserdefinedQuizResultModel userdefinedQuizResultModel =
          UserdefinedQuizResultModel(
        roomName: roomModel.roomName,
        roomId: roomModel.roomId,
        quizName: quizModel!.quizName,
        ownerName: roomModel.ownerName,
        score: score,
        createdAt: Timestamp.now(),
        totalScore: quizModel!.numberOfQuestions,
      );
      await FirebaseFirestore.instance
          .collection('results/${userController.userModel!.uid}/userDefined')
          .doc(roomModel.roomId)
          .set(userdefinedQuizResultModel.toJson());
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
