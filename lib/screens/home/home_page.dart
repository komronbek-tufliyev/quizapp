import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/category_controller.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/routes/route_helper.dart';
import 'package:quizapp/screens/Predefined/quiz_list_page.dart';

import '../../controllers/auth_controller.dart';
import '../../models/category_model.dart';
import '../../models/user_model.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/effects/button_press_effect_container.dart';
import '../../widgets/icon_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double gridWidth = Dimensions.deviceScreenWidth * 0.78;
  final double gridCrossAxisSpacing = Dimensions.width30;
  final double gridMainAxisSpacing = Dimensions.height15;
  late final double gridContainerSize;
  UserModel? userModel;
  int listViewItemCount = 3;

  List<String> listRouteList = [
    RouteHelper.getCreateQuizPage(),
    RouteHelper.getJoinRoomPage(),
    RouteHelper.getShareRoomsPage(),
  ];

  List<String> listTitle1List = [
    "Create",
    "Join in",
    "Share",
  ];

  List<String> listTitle2List = [
    "Quiz",
    "Quiz",
    "Rooms",
  ];

  //override init method
  @override
  void initState() {
    super.initState();
    //fetching the user data from the firestore
    gridContainerSize = (gridWidth - (gridCrossAxisSpacing * 2)) / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _upperContainer(),
        SizedBox(
          height: Dimensions.height20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BigText(
                text: "Choose Categories",
                textColor: AppColors.titleTextColor,
                size: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.getAllCategoriesPage());
                },
                child: const CustomText(
                  text: "See All",
                  textColor: Color(0xFF2ad3f9),
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Dimensions.height20,
        ),
        Center(
          child: SizedBox(
            width: gridWidth,
            height: Dimensions.deviceScreenHeight * 0.40,
            child: GetBuilder<CategoryController>(
              builder: (categoryController) {
                return categoryController.preDefinedCategoryList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: Dimensions.height10),
                        itemCount:
                            categoryController.preDefinedCategoryList.length > 4
                                ? 4
                                : categoryController
                                    .preDefinedCategoryList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: gridCrossAxisSpacing,
                            mainAxisSpacing: gridMainAxisSpacing,
                            crossAxisCount: 2),
                        itemBuilder: (context, index) =>
                            _buildGridViewContainerForPreDefinedCategories(
                                index,
                                categoryController
                                    .preDefinedCategoryList[index],
                                categoryController
                                    .preDefinedCategoryImageUrlList[index]),
                      );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _upperContainer() {
    return Stack(
      children: [
        Container(
          height:
              Dimensions.deviceScreenHeight * 0.30 + Dimensions.statusBarHeight,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: AppColors.mainBlueColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.height35),
                bottomRight: Radius.circular(Dimensions.height35),
              )),
        ),
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
        //Back button
        Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                top: Dimensions.statusBarHeight + Dimensions.height10,
                right: Dimensions.width30,
                left: Dimensions.width30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(Dimensions.width15 / 3),
                        height: Dimensions.responsiveHeight(45),
                        width: Dimensions.responsiveHeight(45),
                        decoration: BoxDecoration(
                            color: AppColors.logoBlueColor.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(Dimensions.height10),
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
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  const CustomText(
                    text: "Welcome Back!",
                    size: 23,
                    fontWeight: FontWeight.w300,
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  GetBuilder<UserController>(builder: (userController) {
                    return BigText(
                      text: userController.userModel == null
                          ? "User Loading..."
                          : userController.userModel!.name,
                      size: 30,
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            SizedBox(
              height: Dimensions.height120 * 1.5,
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: listViewItemCount,
                itemBuilder: (context, index) => _buildListViewContainer(index),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListViewContainer(int index) {
    return Container(
      width: Dimensions.deviceScreenHeight * 0.19,
      decoration: BoxDecoration(
        gradient: AppColors.homePageGradients[(index % 3)],
        borderRadius: BorderRadius.circular(Dimensions.height15),
        image: const DecorationImage(
            image: AssetImage("assets/images/effect.png"), fit: BoxFit.fill),
      ),
      margin: EdgeInsets.only(
        left: Dimensions.width20,
        right: listViewItemCount == index + 1 ? Dimensions.width20 : 0,
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dimensions.height10,
                ),
                CustomText(
                  text: listTitle1List[index],
                  textColor: Colors.white,
                  size: 25,
                ),
                SizedBox(
                  height: Dimensions.height10 / 2,
                ),
                BigText(
                  text: listTitle2List[index],
                  textColor: Colors.white,
                  size: 35,
                ),
              ],
            ),
            ButtonPressEffectContainer(
              onTapFunction: () {
                Get.toNamed(listRouteList[index]);
              },
              margin: EdgeInsets.only(top: Dimensions.height10),
              height: Dimensions.height40,
              width: Dimensions.height60,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/arrowBoxWithOpacity.png"),
                    fit: BoxFit.fill),
              ),
              child: const SizedBox(height: 0),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGridViewContainerForPreDefinedCategories(
      int index, CategoryModel categoryModel, String? imageUrl) {
    index = index % 4;
    return ButtonPressEffectContainer(
      onTapFunction: () {
        Get.to(() => QuizListPage(categoryModel: categoryModel));
      },
      height:
          0, //the size is controlled automatically by the gridview and is not needed to be set manually as height and width. But it is set to 0 because height and width are required parameters of buttonPressEffectContainer widget.
      width: 0,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: Dimensions.deviceScreenWidth * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.height10 / 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(2, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    CustomText(
                      text: categoryModel.name,
                      size: 20,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.gridTextColors[index],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Dimensions.deviceScreenWidth * 0.3 / 1.3,
              width: Dimensions.deviceScreenWidth * 0.3 / 1.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    imageUrl!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
