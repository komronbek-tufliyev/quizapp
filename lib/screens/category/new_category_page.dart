import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/category_image_controller.dart';
import '../../controllers/category_controller.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/effects/button_press_effect_container.dart';
import '../../widgets/icon_container.dart';

class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({super.key});

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  //categoryImageController
  final CategoryImageController categoryImageController = Get.find();
  final CategoryController categoryController = Get.find();
  //text editing controllers
  final TextEditingController _nameController = TextEditingController();

  //defining errors for text fields
  String? nameError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        isFormValid();
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
                      child: const BigText(text: "New Category"),
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
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.height5),
                        const Center(
                          child: CustomText(
                            text: "Create New Category",
                            fontWeight: FontWeight.w500,
                            textColor: Colors.black,
                            size: 20,
                          ),
                        ),
                        SizedBox(height: Dimensions.height30),
                        const BigText(
                          text: "Category Name",
                          textColor: Colors.black,
                          size: 16,
                        ),
                        SizedBox(height: Dimensions.height20),
                        AppTextField(
                          textEditingController: _nameController,
                          hintText: "Your Category Name",
                          errorText: nameError,
                        ),
                        SizedBox(height: Dimensions.height30),
                        const BigText(
                          text: "Display Image",
                          textColor: Colors.black,
                          size: 16,
                        ),
                        SizedBox(height: Dimensions.height20),
                        Obx(
                          () => ButtonPressEffectContainer(
                            onTapFunction: () {
                              categoryImageController.pickImage();
                            },
                            height: Dimensions.height60 *
                                2.5, //the size is controlled automatically by the gridview and is not needed to be set manually as height and width. But it is set to 0 because height and width are required parameters of buttonPressEffectContainer widget.
                            width: Dimensions.height60 * 2.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: AppColors.shadowBlackColor,
                                    offset: Offset(0, 5),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              borderRadius:
                                  BorderRadius.circular(Dimensions.height10),
                            ),
                            child: !categoryImageController.hasImage.value
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.photoFilm,
                                        size: Dimensions.height60,
                                        color: AppColors.textColor,
                                      ),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      const CustomText(
                                        text: "Choose",
                                        size: 20,
                                        fontWeight: FontWeight.w500,
                                        textColor: AppColors.textColor,
                                      ),
                                      const CustomText(
                                        text: "Image",
                                        size: 20,
                                        fontWeight: FontWeight.w500,
                                        textColor: AppColors.textColor,
                                      ),
                                    ],
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.height10),
                                      image: DecorationImage(
                                        image: FileImage(categoryImageController
                                            .compressedFileToUpload!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonPressEffectContainer(
                        onTapFunction: () async {
                          if (isFormValid()) {
                            await categoryController.createCategory(
                                _nameController.text.trim(),
                                categoryImageController.compressedFileToUpload);
                            categoryController
                                .getUserDefinedCategoriesListAndImageUrls();
                            Get.back();
                          }
                        },
                        height: Dimensions.height60,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.mainBlueColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: CustomText(
                            text: "Continue",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isFormValid() {
    bool isNameValid = false;

    //validating question
    if (_nameController.text.isEmpty) {
      setState(() {
        nameError = "Name Cannot be empty";
      });
    } else if (_nameController.text.length < 3) {
      setState(() {
        nameError = "Name must be at least 3 characters";
      });
    } else {
      setState(() {
        nameError = null;
      });
      isNameValid = true;
    }

    if (isNameValid) {
      return true;
    } else {
      return false;
    }
  }
}
