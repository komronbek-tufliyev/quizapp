import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/auth_controller.dart';
import 'package:quizapp/controllers/create_quiz_controller.dart';
import 'package:quizapp/controllers/profile_image_controller.dart';
import 'package:quizapp/controllers/quiz_list_controller.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/firebase_options.dart';
import 'package:quizapp/utilities/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/analyticsController.dart';
import '../controllers/category_controller.dart';
import '../controllers/category_image_controller.dart';
import '../controllers/create_room_controller.dart';
import '../controllers/history_controller.dart';
import '../controllers/join_room_controller.dart';
import '../controllers/quiz_questions_controller.dart';
import '../controllers/room_controller.dart';

Future<void> init() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  if (!sharedPreferences.containsKey(AppConstants.firstLoad)) {
    sharedPreferences.setBool(AppConstants.firstLoad, true);
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseFirestore.instance.terminate();
  await FirebaseFirestore.instance
      .clearPersistence(); //clears the userdata from the firebase stored in the device
  Get.lazyPut(() => sharedPreferences, fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => ProfileImageController(), fenix: true);
  Get.lazyPut(() => CategoryImageController(), fenix: true);
  Get.lazyPut(() => CategoryController(), fenix: true);
  Get.lazyPut(() => CreateQuizController(), fenix: true);
  Get.lazyPut(() => CreateRoomController(), fenix: true);
  Get.lazyPut(() => RoomController(), fenix: true);
  Get.lazyPut(() => UserController(), fenix: true);
  Get.lazyPut(() => QuizListController(), fenix: true);
  Get.lazyPut(() => QuizQuestionsController(), fenix: true);
  Get.lazyPut(() => JoinRoomController(), fenix: true);
  Get.lazyPut(() => AnalyticsController(), fenix: true);
  Get.lazyPut(() => HistoryController(), fenix: true);
}
