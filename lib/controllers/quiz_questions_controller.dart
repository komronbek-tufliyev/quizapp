import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/category_controller.dart';
import 'package:quizapp/controllers/quiz_list_controller.dart';
import 'package:quizapp/controllers/room_controller.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/models/quiz_question_model.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';

import '../models/room_model.dart';

class QuizQuestionsController extends GetxController {
  final RoomController roomController = Get.find();
  final UserController userController = Get.find();
  final QuizListController quizListController = Get.find();
  List<QuizQuestionModel> questionList = [];
  bool isChanged = false;

  void setQuestionModel(List<QuizQuestionModel> questionList) {
    this.questionList = [...questionList];
    update();
  }

  void updateQuestionList(
      {required int index, required QuizQuestionModel quizQuestionModel}) {
    questionList[index] = quizQuestionModel;
    update();
  }

  void setChanged(bool isChanged) {
    this.isChanged = isChanged;
    update();
  }

  Future<bool> updateQuestionListToDatabase({
    required String quizId,
    required String categoryUid,
    required int index,
  }) async {
    showProgressIndicatorDialog();
    bool result = await FirebaseCommonFunctions.updateDocumentInCollection(
        collectionReference: FirebaseFirestore.instance.collection(
            "categories/${userController.userModel!.uid}/categoryList/$categoryUid/quizList"),
        documentId: quizId,
        data: {
          "quizQuestions": (questionList).map((e) => e.toJson()).toList()
        });
    if (result) {
      Navigator.of(Get.context!).pop();
      //! this is just to reflect the changes to the quizListController list without fetching the data again
      quizListController.quizList[index] = QuizModel(
          quizId: quizId,
          quizPassword: quizListController.quizList[index].quizPassword,
          createdAt: quizListController.quizList[index].createdAt,
          quizName: quizListController.quizList[index].quizName,
          numberOfQuestions:
              quizListController.quizList[index].numberOfQuestions,
          quizTimeDuration: quizListController.quizList[index].quizTimeDuration,
          quizQuestions: questionList);
      quizListController.update();
      //!
      Get.back();
      showAppSnackbar(
          title: "Success", description: "Data Updated Successfully");
      return true;
    } else {
      showErrorDialog(
          description: "Error Updating data, Please try again later");
      return false;
    }
  }

  Future<bool> deleteQuiz(
      {required String quizID, required String categoryID}) async {
    showProgressIndicatorDialog();
    await roomController.getRoomList();
    List<RoomModel> roomList = roomController.roomList;
    for (var room in roomList) {
      if (room.quizId == quizID) {
        Navigator.of(Get.context!).pop();
        return false;
      }
    }
    await FirebaseCommonFunctions.deleteDocument(
        collectionPath:
            "categories/${userController.userModel!.uid}/categoryList/$categoryID/quizList",
        docName: quizID);
    await quizListController.setQuizList(categoryID);
    Navigator.of(Get.context!).pop();
    return true;
  }
}
