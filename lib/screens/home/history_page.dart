import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/history_controller.dart';
import 'package:quizapp/models/predefined_quiz_result_model.dart';
import '../../controllers/auth_controller.dart';
import '../../models/userDefined_quiz_result_model.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/icon_container.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryController historyController = Get.find();
  @override
  Widget build(BuildContext context) {
    historyController.getPreDefinedQuizHistory();
    historyController.getUserDefinedQuizHistory();
    return Stack(
      children: [
        upperAppBar(),
        //Profile Box
        Positioned(
          top: Dimensions.height130,
          left: 0,
          right: 0,
          child: Column(
            children: [
              preDefinedQuizHistoryBox(),
              SizedBox(height: Dimensions.height25),
              userDefinedQuizHistoryBox(),
            ],
          ),
        )
      ],
    );
  }

  Widget userDefinedQuizHistoryBox() {
    return Container(
      height: Dimensions.height130 * 2.5,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.responsiveWidth(20),
          vertical: Dimensions.responsiveHeight(20)),
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowBlackColor,
              offset: Offset(1, 1),
              blurRadius: 2,
              spreadRadius: 2,
            )
          ]),
      child: Column(
        children: [
          const BigText(
            text: "Other Played Quizzes",
            textColor: AppColors.titleTextColor,
            size: 18,
          ),
          SizedBox(height: Dimensions.height15),
          GetBuilder<HistoryController>(builder: (_) {
            return Expanded(
              child: historyController.isUserDefinedHistoryDataReady
                  ? historyController.userDefinedQuizHistory.isEmpty
                      ? const Center(
                          child: BigText(
                            text: "No Quizzes Played",
                            textColor: Colors.black,
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount:
                              historyController.userDefinedQuizHistory.length,
                          itemBuilder: (context, index) {
                            return buildUserDefinedQuizHistoryItem(index);
                          })
                  : const Center(
                      child: CircularProgressIndicator(
                      color: AppColors.mainBlueColor,
                    )),
            );
          }),
        ],
      ),
    );
  }

  Widget preDefinedQuizHistoryBox() {
    return Container(
      height: Dimensions.height130 * 2,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.responsiveWidth(20),
          vertical: Dimensions.height20),
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowBlackColor,
              offset: Offset(1, 1),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ]),
      child: Column(
        children: [
          const BigText(
            text: "Pre Defined Quizzes",
            textColor: AppColors.titleTextColor,
            size: 18,
          ),
          SizedBox(height: Dimensions.height15),
          GetBuilder<HistoryController>(builder: (_) {
            return Expanded(
              child: historyController.isPredefinedHistoryDataReady
                  ? historyController.preDefinedQuizHistory.isEmpty
                      ? const Center(
                          child: BigText(
                            text: "No Quizzes Played",
                            textColor: Colors.black,
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount:
                              historyController.preDefinedQuizHistory.length,
                          itemBuilder: (context, index) {
                            return buildPredefinedQuizHistoryItem(index);
                          })
                  : const Center(
                      child: CircularProgressIndicator(
                      color: AppColors.mainBlueColor,
                    )),
            );
          }),
        ],
      ),
    );
  }

  Widget buildUserDefinedQuizHistoryItem(int index) {
    UserdefinedQuizResultModel resultModel =
        historyController.userDefinedQuizHistory[index];
    return Container(
      width: double.maxFinite,
      height: Dimensions.height40 * 2,
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhiteColor,
        borderRadius: BorderRadius.circular(Dimensions.height15),
      ),
      child: Row(
        children: [
          SizedBox(width: Dimensions.width15),
          BigText(
            text: (index + 1).toString(),
            textColor: Colors.black,
            size: 16,
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BigText(
                    text: resultModel.quizName,
                    textColor: AppColors.mainBlueColor,
                    size: 16,
                  ),
                  CustomText(
                    text: "By: ${resultModel.ownerName}",
                    textColor: Colors.black,
                    size: 16,
                  ),
                  CustomText(
                    text: "Room: ${resultModel.roomName}",
                    textColor: Colors.black,
                    size: 16,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: Dimensions.width15),
                child: BigText(
                  text: "${resultModel.score}/${resultModel.totalScore}",
                  textColor: AppColors.mainBlueColor,
                  size: 16,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget buildPredefinedQuizHistoryItem(int index) {
    PredefinedQuizResultModel resultModel =
        historyController.preDefinedQuizHistory[index];
    return Container(
      width: double.maxFinite,
      height: Dimensions.height60,
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhiteColor,
        borderRadius: BorderRadius.circular(Dimensions.height15),
      ),
      child: Row(
        children: [
          SizedBox(width: Dimensions.width15),
          BigText(
            text: (index + 1).toString(),
            textColor: Colors.black,
            size: 16,
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BigText(
                    text: resultModel.quizName,
                    textColor: AppColors.mainBlueColor,
                    size: 16,
                  ),
                  CustomText(
                    text: "From: ${resultModel.categoryName}",
                    textColor: Colors.black,
                    size: 16,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: Dimensions.width15),
                child: BigText(
                  text: "${resultModel.score}/${resultModel.totalScore}",
                  textColor: AppColors.mainBlueColor,
                  size: 16,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget upperAppBar() {
    return Container(
      height: Dimensions.responsiveHeight(150) + Dimensions.statusBarHeight,
      width: double.maxFinite,
      decoration: const BoxDecoration(color: AppColors.mainBlueColor),
      child: Stack(
        children: [
          //Left Small Circle Design
          Positioned(
            top: Dimensions.responsiveHeight(50) + Dimensions.statusBarHeight,
            left: Dimensions.responsiveWidth(70),
            child: CircleAvatar(
              backgroundColor: AppColors.lowOpacityWhiteColor,
              radius: Dimensions.responsiveHeight(40),
            ),
          ),
          //Right Large Circle Design
          Positioned(
            top: Dimensions.responsiveHeight(-20),
            right: Dimensions.responsiveWidth(-30),
            child: CircleAvatar(
              backgroundColor: AppColors.lowOpacityWhiteColor,
              radius: Dimensions.responsiveHeight(90),
            ),
          ),
          //Create Quiz Title
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  top: Dimensions.responsiveHeight(25) +
                      Dimensions.statusBarHeight),
              child: const BigText(text: "History"),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              top: Dimensions.statusBarHeight + Dimensions.height20,
              right: Dimensions.width30,
              left: Dimensions.width30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.width15 / 3),
                  height: Dimensions.responsiveHeight(45),
                  width: Dimensions.responsiveHeight(45),
                  decoration: BoxDecoration(
                      color: AppColors.logoBlueColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(Dimensions.height10),
                      border: Border.all(color: AppColors.logoBlueColor)),
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.find<AuthController>().signOut();
                  },
                  child: const IconContainer(
                    iconData: Icons.logout,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
