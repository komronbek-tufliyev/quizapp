import 'dart:convert';

import 'package:get/get.dart';
import 'package:quizapp/models/room_model.dart';
import 'package:quizapp/screens/auth/forgot_password_page.dart';
import 'package:quizapp/screens/auth/sign_up_page.dart';
import 'package:quizapp/screens/boarding/on_boarding_screen.dart';
import 'package:quizapp/screens/category/all_categories_page.dart';
import 'package:quizapp/screens/category/new_category_page.dart';
import 'package:quizapp/screens/createQuiz/create_quiz_page.dart';
import 'package:quizapp/screens/directors/auth_or_main_page_director.dart';
import 'package:quizapp/utilities/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/auth/sign_in_page.dart';
import '../screens/createQuiz/quiz_creation_successful_page.dart';
import '../screens/home/main_screen.dart';
import '../screens/play/join_room_page.dart';
import '../screens/play/quiz_play_page.dart';
import '../screens/room/all_rooms_page.dart';
import '../screens/room/new_room_page.dart';
import '../screens/room/share_rooms_page.dart';

class RouteHelper {
  static final SharedPreferences sharedPreferences = Get.find();
  static const String _onBoardingPage = '/onBoardingScreen';
  static const String _signUpPage = '/signUpPage';
  static const String _signInPage = '/signInPage';
  static const String _forgotPasswordPage = '/forgotPasswordPage';
  static const String _createQuizPage = '/createQuizPage';
  static const String _newCategoryPage = '/newCategoryPage';
  static const String _newRoomPage = '/newRoomPage';
  static const String _joinRoomPage = '/joinRoomPage';
  static const String _quizPlayPage = '/quizPlayPage';
  static const String _quizCreationSuccessfulPage =
      '/quizCreationSuccessfulPage';
  static const String _allCategoriesPage = '/allCategoriesPage';
  static const String _allRoomsPage = '/allRoomsPage';
  static const String _shareRoomsPage = '/shareRoomsPage';
  // static const String _initialPage = '/';
  static const String _mainPage = '/mainPage';
  static const String _authOrMainPageDirector = '/authOrMainPageDirector';

  static getOnBoardingPage() => _onBoardingPage;
  static getSignUpPage() => _signUpPage;
  static getSignInPage() => _signInPage;
  static getForgotPasswordPage() => _forgotPasswordPage;
  static getCreateQuizPage() => _createQuizPage;
  static getNewCategoryPage() => _newCategoryPage;
  static getNewRoomPage() => _newRoomPage;
  static getJoinRoomPage() => _joinRoomPage;
  static getQuizPlayPage() => _quizPlayPage;
  static getQuizCreationSuccessfulPage({
    required String quizName,
    required String quizId,
    required String passWord,
    required String numberOfQuestions,
  }) =>
      "$_quizCreationSuccessfulPage?quizName=$quizName&quizId=$quizId&passWord=$passWord&numberOfQuestions=$numberOfQuestions";
  static getAllCategoriesPage() => _allCategoriesPage;
  static getAllRoomsPage() => _allRoomsPage;
  static getShareRoomsPage() => _shareRoomsPage;
  static getMainPage() => _mainPage;
  static getAuthOrMainPageDirector() => _authOrMainPageDirector;
  static getInitialPage() {
    bool firstInitialize = true;
    if (sharedPreferences.containsKey(AppConstants.firstLoad)) {
      firstInitialize = sharedPreferences.getBool(AppConstants.firstLoad)!;
    }
    if (firstInitialize) {
      return _onBoardingPage;
    } else {
      return _authOrMainPageDirector;
    }
  }

  static List<GetPage> routes = [
    GetPage(
      name: _onBoardingPage,
      page: () => const OnBoardingScreen(),
    ),
    GetPage(
      name: _signUpPage,
      page: () => const SignUpPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _signInPage,
      page: () => const SignInPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _forgotPasswordPage,
      page: () => const ForgotPasswordPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _authOrMainPageDirector,
      page: (() => const AuthOrMainPageDirector()),
    ),
    GetPage(
      name: _mainPage,
      page: () => const MainScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _createQuizPage,
      page: () => const CreateQuizPage(),
    ),
    GetPage(
      name: _newCategoryPage,
      page: () => const NewCategoryPage(),
    ),
    GetPage(
      name: _newRoomPage,
      page: () => const NewRoomPage(),
    ),
    GetPage(
      name: _joinRoomPage,
      page: () => const JoinRoomPage(),
    ),
    GetPage(
        name: _quizPlayPage,
        page: () {
          var roomModel = Get.arguments[0];
          return QuizPlayPage(roomModel: roomModel);
        }),
    GetPage(
        name: _quizCreationSuccessfulPage,
        page: () {
          final quizName = Get.parameters['quizName'];
          final quizId = Get.parameters['quizId'];
          final passWord = Get.parameters['passWord'];
          final numberOfQuestions = Get.parameters['numberOfQuestions'];
          return QuizCreationSuccessfulPage(
            quizId: quizId!,
            quizName: quizName!,
            passWord: passWord!,
            numberOfQuestions: numberOfQuestions!,
          );
        },
        transition: Transition.rightToLeft),
    GetPage(
      name: _allCategoriesPage,
      page: () => const AllCategoriesPage(),
    ),
    GetPage(
      name: _allRoomsPage,
      page: () => AllRoomsPage(),
    ),
    GetPage(
      name: _shareRoomsPage,
      page: () => ShareRoomsPage(),
    ),
  ];
}
