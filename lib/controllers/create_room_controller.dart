import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/quiz_list_controller.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/utilities/app_colors.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';
import 'package:quizapp/widgets/app_text_field.dart';
import 'package:uuid/uuid.dart';
import '../models/room_model.dart';
import '../utilities/dimensions.dart';
import '../widgets/big_text.dart';
import '../widgets/small_text.dart';

class CreateRoomController extends GetxController {
  final UserController userController = Get.find();
  final QuizListController _quizListController = Get.find();
  List<QuizModel> quizList = [];
  RoomModel? roomModel;
  String categoryID = "";
  String quizID = "";
  RxString roomPassword = '-'.obs;
  RxString roomId = '-'.obs;

  //text editing controllers
  final TextEditingController roomNameController = TextEditingController();

  int questionCount = 50;
  bool showQuestionAddPage = false;
  Object? categoryDropdownValue;
  Object? quizDropdownValue;

  //defining errors for text fields
  String? quizNameError;
  String? categoryError;
  String? quizError;

  CreateRoomController() {
    roomId.value = const Uuid().v4().toString();
  }

  void setQuizList({required String categoryId}) async {
    bool result = await _quizListController.setQuizList(categoryId);
    if (result) {
      quizList = _quizListController.quizList;
    } else {
      quizList = [];
      roomPassword.value = '-';
      quizDropdownValue = null;
    }
    update();
  }

  void noQuizHandler() {
    quizDropdownValue = null;
    // roomPassword.value = '-';
  }

  void updateCategoryDropdownValue(Object? value) {
    categoryDropdownValue = value;
    update();
  }

  void updateQuizDropdownValue(Object? value) {
    quizDropdownValue = value;
    update();
  }

  void updateRoomPassword(String password) {
    roomPassword.value = password;
  }

  void showQuestionAddPageFunction(bool value) {
    showQuestionAddPage = value;
    update();
  }

  bool isRoomDetailsFormValid() {
    bool isRoomNameValid = false;
    bool isQuizCategoryValid = false;
    bool isQuizValid = false;
    if (roomNameController.text.isEmpty) {
      quizNameError = "Quiz Name cannot be empty";
    } else if (roomNameController.text.length < 3) {
      quizNameError = "Quiz Name must be at least 3 characters";
    } else {
      quizNameError = null;
      isRoomNameValid = true;
    }

    if (categoryDropdownValue == null) {
      print("categoryDropdownValue is null");
      categoryError = "Please select a category";
    } else {
      categoryError = null;
      isQuizCategoryValid = true;
    }

    if (quizDropdownValue == null) {
      quizError = "Please select a quiz";
    } else {
      quizError = null;
      isQuizValid = true;
    }

    if (isRoomNameValid && isQuizCategoryValid && isQuizValid) {
      return true;
    } else {
      // quizNameError = quizNameError;
      // categoryError = categoryError;
      // quizError = quizError;
      update();
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
                              roomPassword.value = passwordController.text;
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

  Future<void> createRoomModel() async {
    categoryID = categoryDropdownValue!.toString();
    quizID = quizDropdownValue!.toString();
    roomModel = RoomModel(
      roomId: roomId.value,
      roomName: roomNameController.text.trim(),
      quizId: quizID,
      categoryId: categoryID,
      createdAt: Timestamp.now(),
      quizName: quizList
          .firstWhere(
              (element) => (element.quizId == quizDropdownValue.toString()))
          .quizName,
      quizPassword: roomPassword.value,
      ownerId: userController.userModel!.uid,
      ownerName: userController.userModel!.name,
    );
  }

  Future<bool> addQuizToDatabase() async {
    await createRoomModel();
    try {
      await FirebaseCommonFunctions.addDocumentWithNameToCollection(
        collectionReference: FirebaseFirestore.instance.collection("rooms"),
        data: roomModel!.toJson(),
        documentName: roomId.value,
      );
      await FirebaseCommonFunctions.addDocumentWithNameToCollection(
        collectionReference: FirebaseFirestore.instance.collection("roomsList"),
        documentName: userController.userModel!.uid,
        data: {"id": userController.userModel!.uid},
      );
      await FirebaseCommonFunctions.addDocumentWithNameToCollection(
        collectionReference: FirebaseFirestore.instance
            .collection("roomsList/${userController.userModel!.uid}/rooms"),
        documentName: roomId.value,
        data: roomModel!.toJson(),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
