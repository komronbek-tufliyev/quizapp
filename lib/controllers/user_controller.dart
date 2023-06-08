// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/profile_image_controller.dart';
import 'package:quizapp/models/user_model.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';

class UserController extends GetxController {
  ProfileImageController profileImageController = Get.find();
  UserModel? _userModel;
  UserController() {
    setUserModel();
    // setUserModelFromLocalStorage();
  }

  UserModel? get userModel => _userModel;

  Stream<bool> setUserModel() async* {
    bool result = false;
    while (!result) {
      showProgressIndicatorDialog();
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          _userModel = UserModel.fromJson(value.data()!);
        });
        update();
        profileImageController
            .setProfileImageReference(userModel!.uid.toString());
        profileImageController.setProfileImageUrl();
        result = true;
        Navigator.of(Get.context!).pop();
      } on FirebaseException catch (e) {
        _userModel = null;
        update();
        result = false;
        if (e.code == 'unavailable') {
          await showErrorDialog(
            description: "No internet connection. Please try again later.",
            userActionButtonName: "Reload",
            onPressed: () => Navigator.of(Get.context!).pop(),
          );
        }
      } catch (e) {
        _userModel = null;
        update();
        result = false;
      }
      yield result;
    }
    // return Stream.value(userModel!);
  }
}
