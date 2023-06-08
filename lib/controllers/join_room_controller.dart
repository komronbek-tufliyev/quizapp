import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/models/room_model.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';

class JoinRoomController extends GetxController {
  TextEditingController roomIdController = TextEditingController();
  TextEditingController roomPasswordController = TextEditingController();
  String? roomIdErrorText;
  String? roomPasswordErrorText;
  RoomModel? roomModel;
  String? ownerProfileImageUrl;

  bool validateRoomID() {
    if (roomIdController.text.isEmpty) {
      roomIdErrorText = "Room ID cannot be empty";
      update();
      return false;
    }
    roomIdErrorText = null;
    update();
    return true;
  }

  bool validateRoomPassword() {
    if (roomPasswordController.text.isEmpty) {
      roomPasswordErrorText = "Room Password cannot be empty";
      update();
      return false;
    }
    roomPasswordErrorText = null;
    update();
    return true;
  }

  Future<bool> searchRoom() async {
    showProgressIndicatorDialog();
    bool result = await FirebaseCommonFunctions.checkIfDocumentExists(
      FirebaseFirestore.instance.collection("rooms"),
      roomIdController.text.trim(),
    );
    if (!result) {
      showErrorDialog(
          description:
              "Room with ID \"${roomIdController.text.trim()}\" does not exist");
      return false;
    } else {
      bool res = false;
      await FirebaseCommonFunctions.getDocumentFromCollection(
              collectionReference:
                  FirebaseFirestore.instance.collection("rooms"),
              documentId: roomIdController.text.trim())
          .then((value) {
        if (value != null) {
          roomModel = RoomModel.fromJson(value.data() as Map<String, dynamic>);
          Get.back();
          res = true;
        } else {
          showErrorDialog(description: "Error while fetching room details");
          res = false;
        }
      });
      return res;
    }
  }

  void getOwnerProfileImageUrl() async {
    try {
      ownerProfileImageUrl = await FirebaseStorage.instance
          .ref("profileImages")
          .child(roomModel!.ownerId)
          .getDownloadURL();
      update();
    } catch (e) {
      print(e);
      ownerProfileImageUrl = null;
    }
  }
}
