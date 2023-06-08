import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/models/room_model.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';

import '../utilities/firebase_common_functions.dart';

class RoomController extends GetxController {
  UserController userController = Get.find();
  final List<RoomModel> roomList = [];
  bool isRoomDataReady = false;

  Future<void> getRoomList() async {
    roomList.clear();
    isRoomDataReady = false;
    bool result = await FirebaseCommonFunctions.checkIfDocumentExists(
        FirebaseFirestore.instance.collection("roomsList"),
        userController.userModel!.uid);
    if (result) {
      var docList = await FirebaseCommonFunctions.getDocList(
          collectionReference: FirebaseFirestore.instance
              .collection("roomsList/${userController.userModel!.uid}/rooms"),
          isDescending: true);
      roomList.clear();
      for (var element in docList) {
        roomList
            .add(RoomModel.fromJson(element.data() as Map<String, dynamic>));
      }
      isRoomDataReady = true;
      update();
    } else {
      isRoomDataReady = true;
      update();
    }
  }

  Future<bool> deleteRoom({required String roomID}) async {
    showProgressIndicatorDialog();
    bool success = await FirebaseCommonFunctions.deleteDocument(
        collectionPath: "rooms", docName: roomID);
    if (success) {
      bool nextSuccess = await FirebaseCommonFunctions.deleteDocument(
          collectionPath: "roomsList/${userController.userModel!.uid}/rooms",
          docName: roomID);
      if (nextSuccess) {
        await getRoomList();
        Navigator.of(Get.context!).pop();
        return true;
      } else {
        showErrorDialog(description: "Something Went Wrong");
        return false;
      }
    } else {
      showErrorDialog(description: "Something Went Wrong");
      return false;
    }
  }
}
