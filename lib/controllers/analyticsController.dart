import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/room_controller.dart';
import 'package:quizapp/models/result_model.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';

class AnalyticsController extends GetxController {
  final RoomController roomController = Get.find();
  List<Map<String, dynamic>> roomDetailsList = [];
  bool isDataReady = false;
  String selectedRoomId = "";
  String selectedRoomName = "";
  List<ResultModel> resultModelList = [];

  AnalyticsController() {
    getRoomList();
  }

  Future<bool> getRoomList() async {
    isDataReady = false;
    try {
      await roomController.getRoomList();
      roomDetailsList.clear();
      for (var element in roomController.roomList) {
        roomDetailsList.add({"name": element.roomName, "id": element.roomId});
      }
      update();
      isDataReady = true;
      return true;
    } catch (e) {
      update();
      isDataReady = true;
      return false;
    }
  }

  Future<bool> getRoomResults() async {
    try {
      resultModelList.clear();
      await FirebaseCommonFunctions.getDocListWithOrderBy(
              orderBy: "score",
              collectionReference: FirebaseFirestore.instance
                  .collection("rooms/$selectedRoomId/results"),
              isDescending: true)
          .then((value) {
        for (var element in value) {
          resultModelList.add(
            ResultModel.fromJson(element.data() as Map<String, dynamic>),
          );
          update();
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
