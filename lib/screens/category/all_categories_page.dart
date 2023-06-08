import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/category_controller.dart';
import 'package:quizapp/models/category_model.dart';
import 'package:quizapp/routes/route_helper.dart';
import 'package:quizapp/screens/Predefined/quiz_list_page.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/effects/button_press_effect_container.dart';
import '../../widgets/icon_container.dart';
import 'category_detail_page.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhiteColor,
        body: Stack(
          children: [
            Container(
              height:
                  Dimensions.responsiveHeight(150) + Dimensions.statusBarHeight,
              width: double.maxFinite,
              decoration: const BoxDecoration(color: AppColors.mainBlueColor),
              child: Stack(
                children: [
                  //Left Small Circle Design
                  Positioned(
                    top: Dimensions.responsiveHeight(50) +
                        Dimensions.statusBarHeight,
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
                  Positioned(
                    top: Dimensions.responsiveHeight(20) +
                        Dimensions.statusBarHeight,
                    left: Dimensions.responsiveWidth(20),
                    child: ButtonPressEffectContainer(
                      onTapFunction: () {
                        Get.back();
                      },
                      height: Dimensions.height40,
                      width: Dimensions.height40,
                      child: const IconContainer(
                        iconData: Icons.arrow_back_ios,
                        iconLeftPadding: 10,
                      ),
                    ),
                  ),
                  //Create Quiz Title
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.responsiveHeight(25) +
                              Dimensions.statusBarHeight),
                      child: const BigText(text: "Choose Categories"),
                    ),
                  ),
                ],
              ),
            ),
            //Question Box
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimensions.deviceScreenHeight -
                    Dimensions.responsiveHeight(140),
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.responsiveWidth(20), vertical: 20),
                margin: EdgeInsets.only(
                    left: Dimensions.responsiveWidth(20),
                    right: Dimensions.responsiveWidth(20),
                    bottom: Dimensions.responsiveHeight(20),
                    top: Dimensions.statusBarHeight),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.shadowBlackColor,
                          offset: Offset(0, 5),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ]),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ButtonPressEffectContainer(
                      //     decoration: BoxDecoration(
                      //         color: AppColors.mainBlueColor,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     child: BigText(text: "+ New Category"),
                      //     height: Dimensions.height50,
                      //     width: double.maxFinite,
                      //     onTapFunction: () {}),
                      const BigText(
                        text: "Predefined Categories",
                        size: 20,
                        textColor: AppColors.titleTextColor,
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      GetBuilder<CategoryController>(
                          builder: (categoryController) {
                        return categoryController.preDefinedCategoryList.isEmpty
                            ? const CircularProgressIndicator()
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                    bottom: Dimensions.height10),
                                itemCount: categoryController
                                        .preDefinedCategoryList.isEmpty
                                    ? null
                                    : categoryController
                                        .preDefinedCategoryList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: Dimensions.height20,
                                        mainAxisSpacing: Dimensions.height20,
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) =>
                                    _buildGridViewContainerForPreDefinedCategories(
                                        index,
                                        categoryController
                                            .preDefinedCategoryList[index],
                                        categoryController
                                                .preDefinedCategoryImageUrlList[
                                            index]),
                              );
                      }),
                      SizedBox(
                        height: Dimensions.height30,
                      ),
                      const BigText(
                        text: "Your Categories",
                        size: 20,
                        textColor: AppColors.titleTextColor,
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      GetBuilder<CategoryController>(
                          builder: (categoryController) {
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: Dimensions.height10),
                          crossAxisCount: 2,
                          crossAxisSpacing: Dimensions.height20,
                          mainAxisSpacing: Dimensions.height20,
                          children: [
                            ButtonPressEffectContainer(
                              onTapFunction: () {
                                Get.toNamed(RouteHelper.getNewCategoryPage());
                              },
                              height:
                                  0, //the size is controlled automatically by the gridview and is not needed to be set manually as height and width. But it is set to 0 because height and width are required parameters of buttonPressEffectContainer widget.
                              width: 0,
                              decoration: BoxDecoration(
                                color: AppColors.logoBluishWhiteColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.height10 / 2),
                                boxShadow: const [
                                  BoxShadow(
                                      color: AppColors.shadowBlackColor,
                                      offset: Offset(0, 2),
                                      blurRadius: 2,
                                      spreadRadius: 1)
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: Dimensions.height60,
                                    color: AppColors.mainBlueColor,
                                  ),
                                  SizedBox(
                                    height: Dimensions.height10,
                                  ),
                                  const CustomText(
                                    text: "New",
                                    size: 20,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppColors.textColor,
                                  ),
                                  const CustomText(
                                    text: "Category",
                                    size: 20,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppColors.textColor,
                                  ),
                                ],
                              ),
                            ),
                            ...List.generate(
                                categoryController
                                    .userDefinedCategoryList.length,
                                (index) =>
                                    _buildGridViewContainerForUserDefinedCategories(
                                        index,
                                        categoryController
                                            .userDefinedCategoryList[index],
                                        categoryController
                                                .userDefinedCategoryImageUrlList[
                                            index])),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
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
        Get.to(
          () => QuizListPage(categoryModel: categoryModel),
        );
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

  Widget _buildGridViewContainerForUserDefinedCategories(
      int index, CategoryModel categoryModel, String? imageUrl) {
    index = index % 4;
    return ButtonPressEffectContainer(
      onTapFunction: () {
        // Get.toNamed("alsjdflajsd", arguments: categoryModel);
        Get.to(
          () => CategoryDetailPage(
            categoryModel: categoryModel,
          ),
        );
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
            child: categoryModel.displayImage
                ? Container(
                    height: Dimensions.deviceScreenWidth * 0.3 / 1.3,
                    width: Dimensions.deviceScreenWidth * 0.3 / 1.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Dimensions.deviceScreenWidth * 0.3 / 1.3 / 2),
                      image: DecorationImage(
                        image: NetworkImage(
                          imageUrl!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: Dimensions.deviceScreenWidth * 0.3 / 1.3 / 2,
                    backgroundColor: AppColors.gridTextColors[index],
                    child: CustomText(
                      text: categoryModel.name.substring(0, 1),
                      size: 30,
                      fontWeight: FontWeight.w500,
                      textColor: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
