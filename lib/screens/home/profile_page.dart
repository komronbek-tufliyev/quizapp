// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/profile_image_controller.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/widgets/effects/button_press_effect_container.dart';
import '../../controllers/auth_controller.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/icon_container.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> badgeLowerContainerText = [
    "World Rank",
    "Local Rank",
    "Score",
  ];

  List<String> badgeLowerContainerValue = [
    "7,373,025",
    "1,913",
    "5,400",
  ];

  List<String> badgeLowerContainerImages = [
    "assets/images/worldRank.png",
    "assets/images/localRank.png",
    "assets/images/score.png",
  ];

  List<String> badgeUpperContainerImages = [
    "assets/images/badge1.png",
    "assets/images/badge2.png",
    "assets/images/badge3.png",
  ];

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
          child: Column(
            children: [
              profileBox(),
              SizedBox(height: Dimensions.height25),
              badgeBox(),
            ],
          ),
        )
      ],
    );
  }

  Widget badgeBox() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.height10),
            width: double.maxFinite,
            height: Dimensions.height130 * 1.1,
            decoration: BoxDecoration(
              color: AppColors.backgroundWhiteColor,
              borderRadius: BorderRadius.circular(Dimensions.height15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const BigText(
                  text: "A journey to be a champ",
                  textColor: AppColors.titleTextColor,
                  size: 18,
                ),
                SizedBox(height: Dimensions.height10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int index = 0; index < 3; index++)
                        Container(
                          width: Dimensions.width40 * 2,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/hexagon.png",
                              ),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: Dimensions.width40,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      badgeUpperContainerImages[index]),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: Dimensions.height10),
          //Lower Container
          Container(
            padding: EdgeInsets.all(Dimensions.height10),
            width: double.maxFinite,
            height: Dimensions.height60 * 2.2,
            decoration: const BoxDecoration(
              color: AppColors.backgroundWhiteColor,
            ),
            child: Column(
              children: [
                const BigText(
                  text: "Details",
                  textColor: Colors.black,
                  size: 20,
                ),
                SizedBox(height: Dimensions.height10),
                Table(
                  children: [
                    TableRow(children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.height5),
                        child: const BigText(
                          text: "Name: ",
                          textColor: Colors.black,
                          size: 16,
                        ),
                      ),
                      CustomText(
                        text: Get.find<UserController>().userModel!.name,
                        textColor: Colors.black,
                        size: 16,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ]),
                    TableRow(children: [
                      const BigText(
                        text: "Email: ",
                        textColor: Colors.black,
                        size: 16,
                      ),
                      CustomText(
                        text: Get.find<UserController>().userModel!.email,
                        textColor: Colors.black,
                        size: 16,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileBox() {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Obx(
                () {
                  ProfileImageController profileImageController = Get.find();
                  return CircleAvatar(
                    radius: Dimensions.height60,
                    backgroundColor: const Color(0xFF0023FF),
                    backgroundImage:
                        profileImageController.profileImageUrl.value == ""
                            ? null
                            : NetworkImage(
                                profileImageController.profileImageUrl.value,
                              ),
                    child: profileImageController.profileImageUrl.value == ""
                        ? GetBuilder<UserController>(builder: (userController) {
                            return BigText(
                              text: userController.userModel == null
                                  ? "QA"
                                  : userController.userModel!.name[0],
                              size: Dimensions.height50 * 2,
                              textColor: Colors.white,
                            );
                          })
                        : null,
                  );
                },
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: ButtonPressEffectContainer(
                  onTapFunction: () {
                    Get.find<ProfileImageController>().pickImage();
                  },
                  height: Dimensions.height40,
                  width: Dimensions.width40,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/hexagonWithBorder.png",
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: Dimensions.height20,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: Dimensions.height10),
          GetBuilder<UserController>(builder: (userController) {
            return BigText(
              text: userController.userModel == null
                  ? "User Loading..."
                  : userController.userModel!.name,
              textColor: AppColors.titleTextColor,
            );
          }),
          SizedBox(height: Dimensions.height15),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.mainBlueColor,
                    borderRadius: BorderRadius.circular(
                      Dimensions.height10,
                    ),
                  ),
                  height: Dimensions.height40,
                  width: Dimensions.deviceScreenWidth * 0.35,
                  child: const Center(
                    child: CustomText(
                      text: "You're",
                      size: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(width: Dimensions.width20 / 2),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.brightCyanColor,
                    borderRadius: BorderRadius.circular(
                      Dimensions.height10,
                    ),
                  ),
                  height: Dimensions.height40,
                  width: Dimensions.deviceScreenWidth * 0.35,
                  child: const Center(
                    child: CustomText(
                      text: "Awesome",
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          )
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
              child: const BigText(text: "Profile"),
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
