import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/category_controller.dart';
import 'package:quizapp/controllers/room_controller.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/routes/route_helper.dart';
import 'package:quizapp/screens/home/home_page.dart';
import 'package:quizapp/screens/home/profile_page.dart';
import 'package:quizapp/utilities/app_colors.dart';
import 'package:quizapp/utilities/dimensions.dart';
import 'package:quizapp/widgets/exit_enabled_widget.dart';

import 'history_page.dart';
import 'analytics_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final UserController userController = Get.find();
  final CategoryController categoryController = Get.find();
  final RoomController roomController = Get.find();
  final int pageCount = 4;
  final PageController pageController = PageController();

  List<Widget> screens = [
    const HomePage(),
    const HistoryPage(),
    const AnalyticsPage(),
    const ProfilePage(),
  ];

  int currentIndex = 0;

  //override initState
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page!.round();
      });
    });
    categoryController.getPreDefinedCategoriesListAndImageUrls();
    categoryController.getUserDefinedCategoriesListAndImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return ExitEnabledWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            PageView.builder(
                controller: pageController,
                itemCount: pageCount,
                itemBuilder: (context, index) {
                  return screens[index];
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: Dimensions.height20 + Dimensions.height35 * 2.5,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: Dimensions.height20,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        height: Dimensions.height60,
                        decoration: BoxDecoration(
                          color: AppColors.mainBlueColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.height15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                pageController.animateToPage(0,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut);
                              },
                              icon: Icon(
                                Icons.home,
                                color: currentIndex == 0
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.linear);
                              },
                              icon: Icon(
                                FontAwesomeIcons.clockRotateLeft,
                                size: 20,
                                color: currentIndex == 1
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(
                              width: Dimensions.width30 * 2,
                            ),
                            IconButton(
                              onPressed: () {
                                pageController.animateToPage(2,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.linear);
                              },
                              icon: Icon(
                                Icons.auto_graph,
                                size: 20,
                                color: currentIndex == 2
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                pageController.animateToPage(3,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.linear);
                              },
                              icon: Icon(
                                Icons.person,
                                color: currentIndex == 3
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: Dimensions.height20 + Dimensions.height35 / 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Dimensions.height35 * 2,
                            width: Dimensions.height35 * 2,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundWhiteColor,
                              borderRadius: BorderRadius.circular(
                                Dimensions.height35,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteHelper.getAllRoomsPage());
                              },
                              child: Container(
                                margin: EdgeInsets.all(Dimensions.height5),
                                decoration: BoxDecoration(
                                  color: AppColors.mainBlueColor,
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.height35,
                                  ),
                                ),
                                child: Center(
                                    child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: Dimensions.height35,
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
