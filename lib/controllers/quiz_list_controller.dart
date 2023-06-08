import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/utilities/app_constants.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';

import '../models/quiz_model.dart';

class QuizListController extends GetxController {
  List<QuizModel> _quizList = [];
  List<QuizModel> get quizList => _quizList;
  final UserController userController = Get.find();
  //! these booleans are for creating rooms page
  bool isDataReady = false;
  bool isDataReadyForDropDown = true;
  bool isDataAvailable = true;

  Future<bool> setQuizList(String categoryId) async {
    isDataReadyForDropDown = false;
    _quizList = [];
    update();
    final docList = await FirebaseCommonFunctions.getDocList(
      collectionReference: FirebaseFirestore.instance.collection(
          "categories/${userController.userModel!.uid}/categoryList/$categoryId/quizList"),
      isDescending: true,
    );
    if (docList.isEmpty) {
      isDataReady = true; //! changed
      isDataAvailable = false;
      update();
      return false;
    } else {
      for (int i = 0; i < docList.length; i++) {
        _quizList.add(
          QuizModel.fromJson(
            docList[i].data() as Map<String, dynamic>,
          ),
        );
        update();
      }
      isDataReady = true;
      isDataReadyForDropDown = true;
      isDataAvailable = true;
      update();
      return true;
    }
  }

  Future<bool> setPredefinedQuizList(String categoryId) async {
    isDataReadyForDropDown = false;
    _quizList = [];
    update();
    final docList = await FirebaseCommonFunctions.getDocList(
      collectionReference: FirebaseFirestore.instance.collection(
          "categories/${AppConstants.adminUserId}/categoryList/$categoryId/quizList"),
      isDescending: true,
    );
    if (docList.isEmpty) {
      isDataReady = true; //! changed
      isDataAvailable = false;
      update();
      return false;
    } else {
      for (int i = 0; i < docList.length; i++) {
        _quizList.add(
          QuizModel.fromJson(
            docList[i].data() as Map<String, dynamic>,
          ),
        );
        update();
      }
      isDataReady = true;
      isDataReadyForDropDown = true;
      isDataAvailable = true;
      update();
      return true;
    }
  }
}
