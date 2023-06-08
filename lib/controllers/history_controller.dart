import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/models/predefined_quiz_result_model.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';

import '../models/userDefined_quiz_result_model.dart';

class HistoryController extends GetxController {
  final UserController userController = Get.find();
  bool isPredefinedHistoryDataReady = false;
  bool isUserDefinedHistoryDataReady = false;
  List<PredefinedQuizResultModel> preDefinedQuizHistory = [];
  List<UserdefinedQuizResultModel> userDefinedQuizHistory = [];

  Future<void> getPreDefinedQuizHistory() async {
    preDefinedQuizHistory.clear();
    isPredefinedHistoryDataReady = false;
    try {
      await FirebaseCommonFunctions.getDocList(
              collectionReference: FirebaseFirestore.instance.collection(
                  "results/${userController.userModel!.uid}/preDefined"),
              isDescending: true)
          .then((value) {
        for (var element in value) {
          preDefinedQuizHistory.add(
            PredefinedQuizResultModel.fromJson(
                element.data() as Map<String, dynamic>),
          );
        }
      });

      isPredefinedHistoryDataReady = true;
      update();
    } catch (e) {
      isPredefinedHistoryDataReady = true;
      update();
    }
  }

  Future<void> getUserDefinedQuizHistory() async {
    userDefinedQuizHistory.clear();
    isUserDefinedHistoryDataReady = false;
    try {
      await FirebaseCommonFunctions.getDocList(
              collectionReference: FirebaseFirestore.instance.collection(
                  "results/${userController.userModel!.uid}/userDefined"),
              isDescending: true)
          .then((value) {
        for (var element in value) {
          userDefinedQuizHistory.add(
            UserdefinedQuizResultModel.fromJson(
                element.data() as Map<String, dynamic>),
          );
        }
      });

      isUserDefinedHistoryDataReady = true;
      update();
    } catch (e) {
      isUserDefinedHistoryDataReady = true;
      update();
    }
  }
}
