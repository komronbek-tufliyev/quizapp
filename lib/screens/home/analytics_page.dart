import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/analyticsController.dart';
import 'package:quizapp/widgets/custom_text.dart';
import '../../controllers/auth_controller.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_container.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final AnalyticsController analyticsController = Get.find();
  bool isDetailPage = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        upperAppBar(),
        //Profile Box
        Positioned(
          top: Dimensions.height130,
          left: 0,
          right: 0,
          child: contentBox(),
        )
      ],
    );
  }

  Widget contentBox() {
    return GetBuilder<AnalyticsController>(builder: (_) {
      return Container(
        height: Dimensions.deviceScreenHeight * 0.73,
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.responsiveWidth(Dimensions.width15 / 2),
            vertical: Dimensions.height20),
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.height20),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowBlackColor,
                offset: Offset(1, 1),
                blurRadius: 2,
                spreadRadius: 2,
              ),
            ]),
        child: !isDetailPage ? roomListContentBox() : DetailBox(),
      );
    });
  }

  Widget DetailBox() {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width15 / 3),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDetailPage = false;
                  });
                },
                child: const IconContainer(
                  iconData: Icons.arrow_back,
                  iconColor: Colors.black,
                  iconSize: 30,
                  containerColor: AppColors.logoBlueColor,
                ),
              ),
              SizedBox(width: Dimensions.width15),
              BigText(
                text: analyticsController.selectedRoomName,
                textColor: Colors.black,
                size: 18,
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          Expanded(
              child: Table(
            border: TableBorder.all(color: Colors.black),
            children: [
              const TableRow(
                children: [
                  Center(
                    child: BigText(
                      text: "Name",
                      textColor: Colors.black,
                      size: 16,
                    ),
                  ),
                  Center(
                    child: BigText(
                      text: "Score",
                      textColor: Colors.black,
                      size: 16,
                    ),
                  ),
                ],
              ),
              for (int i = 0;
                  i < analyticsController.resultModelList.length;
                  i++)
                TableRow(
                  children: [
                    Center(
                      child: CustomText(
                        text: analyticsController.resultModelList[i].name,
                        textColor: Colors.black,
                        size: 16,
                      ),
                    ),
                    Center(
                      child: CustomText(
                        text: analyticsController.resultModelList[i].score
                            .toString(),
                        textColor: Colors.black,
                        size: 16,
                      ),
                    ),
                  ],
                )
            ],
          ))
        ],
      ),
    );
  }

  Widget roomListContentBox() {
    return RefreshIndicator(
      onRefresh: () async {
        await analyticsController.getRoomList();
      },
      child: Column(
        children: [
          const BigText(
            text: "Your active rooms",
            textColor: Colors.black,
          ),
          SizedBox(height: Dimensions.height20),
          analyticsController.isDataReady
              ? Expanded(
                  child: analyticsController.roomDetailsList.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: analyticsController.roomDetailsList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  isDetailPage = true;
                                });
                                analyticsController.selectedRoomId =
                                    analyticsController.roomDetailsList[index]
                                        ["id"];
                                analyticsController.selectedRoomName =
                                    analyticsController.roomDetailsList[index]
                                        ["name"];
                                analyticsController.getRoomResults();
                              },
                              child: Container(
                                  height: Dimensions.height60,
                                  width: double.maxFinite,
                                  margin: EdgeInsets.symmetric(
                                      vertical: Dimensions.height5,
                                      horizontal: Dimensions.width15 - 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.height10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.shadowBlackColor,
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: Dimensions.width15,
                                      ),
                                      CustomText(
                                        text: (index + 1).toString(),
                                        textColor: Colors.black,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: Dimensions.width15,
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          text: analyticsController
                                              .roomDetailsList[index]["name"],
                                          textColor: Colors.black,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          },
                        )
                      : const Center(
                          child: CustomText(
                            text: "No active rooms",
                            textColor: Colors.black,
                          ),
                        ),
                )
              : const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainBlueColor,
                    ),
                  ),
                ),
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
              child: const BigText(text: "Analytics"),
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
