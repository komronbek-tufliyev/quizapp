import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/category_controller.dart';
import 'package:quizapp/controllers/quiz_list_controller.dart';
import 'package:quizapp/models/category_model.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/screens/category/quiz/quiz_detail_page.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/widgets/icon_container.dart';
import 'package:quizapp/widgets/page_model.dart';

import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/effects/button_press_effect_container.dart';

class CategoryDetailPage extends StatelessWidget {
  final CategoryController categoryController = Get.find();
  final CategoryModel categoryModel;
  final QuizListController quizListController = Get.find();
  CategoryDetailPage({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    quizListController.setQuizList(categoryModel.uid);
    return PageModel(
      onTapFunction: () {
        Get.back();
      },
      title: categoryModel.name,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                child: const IconContainer(
                  iconData: Icons.delete,
                ),
                onTap: () {
                  showAlertDialog(
                    title: "Delete?",
                    description:
                        "Your all quizzes in the category will be deleted.",
                    buttonText1: "Cancel",
                    buttonText2: "Continue",
                    onPressed2: () async {
                      Navigator.of(Get.context!).pop();
                      bool success = await categoryController.deleteCategory(
                          categoryID: categoryModel.uid);
                      if (success) {
                        Get.back();
                        showAppSnackbar(
                            title: "Success",
                            description: "Category Deleted Successfully");
                      } else {
                        showErrorDialog(
                            description:
                                "This category is being used in one or many of your rooms. Please delete that first!");
                      }
                    },
                  );
                },
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: Dimensions.height10,
              ),
              const BigText(
                text: "Quiz List",
                textColor: AppColors.titleTextColor,
              ),
              SizedBox(
                height: Dimensions.height20,
              ),
              Expanded(
                child: GetBuilder<QuizListController>(
                  builder: (quizListController) {
                    return quizListController.isDataReady
                        ? quizListController.quizList.isEmpty
                            ? const Center(
                                child: CustomText(
                                  text: "No Quiz Found",
                                  textColor: AppColors.textColor,
                                  size: 18,
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20 / 4),
                                physics: const BouncingScrollPhysics(),
                                itemCount: quizListController.quizList.length,
                                itemBuilder: (context, index) {
                                  return buildQuizItem(
                                    index: index + 1,
                                    quizModel:
                                        quizListController.quizList[index],
                                  );
                                },
                              )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mainBlueColor,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuizItem({
    required int index,
    required QuizModel quizModel,
  }) {
    return ButtonPressEffectContainer(
      width: Dimensions.deviceScreenWidth * 0.6,
      height: Dimensions.height60,
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowBlackColor,
            offset: Offset(1, 1),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(Dimensions.height15),
      ),
      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: BigText(
                text: '$index    ${quizModel.quizName}',
                textColor: AppColors.textColor,
                size: 18,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: quizModel.numberOfQuestions.toString(),
                    textColor: AppColors.mainBlueColor,
                    size: 18,
                  ),
                  const CustomText(
                    text: "Questions",
                    textColor: AppColors.textColor,
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTapFunction: () {
        Get.to(() => QuizDetailPage(
            quizModel: quizModel,
            categoryId: categoryModel.uid,
            index: index - 1));
      },
    );
  }
}
