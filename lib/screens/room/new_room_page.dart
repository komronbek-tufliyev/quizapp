import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/quiz_list_controller.dart';
import 'package:quizapp/controllers/room_controller.dart';

import '../../controllers/category_controller.dart';
import '../../controllers/create_room_controller.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/common_ui_functions.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/effects/button_press_effect_container.dart';
import '../../widgets/page_model.dart';

class NewRoomPage extends StatefulWidget {
  const NewRoomPage({super.key});

  @override
  State<NewRoomPage> createState() => _NewRoomPageState();
}

class _NewRoomPageState extends State<NewRoomPage> {
  final CreateRoomController _createRoomController = Get.find();
  @override
  Widget build(BuildContext context) {
    return PageModel(
      onTapFunction: () {
        Get.back();
      },
      title: "New Room",
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _createRoomController.isRoomDetailsFormValid();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.height5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: Dimensions.height60,
                          child: GridView(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: Dimensions.height10,
                                    mainAxisSpacing: Dimensions.height15,
                                    childAspectRatio: 6),
                            children: [
                              const BigText(
                                text: "Room ID:",
                                textColor: Colors.black,
                                size: 16,
                              ),
                              Obx(
                                () => BigText(
                                  text: _createRoomController.roomId.value,
                                  textColor: Colors.black,
                                  size: 16,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const BigText(
                                text: "Room Password:",
                                textColor: Colors.black,
                                size: 16,
                              ),
                              Obx(
                                () => BigText(
                                  text:
                                      _createRoomController.roomPassword.value,
                                  textColor: Colors.black,
                                  size: 16,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonPressEffectContainer(
                            height: Dimensions.height30,
                            width: Dimensions.height30,
                            decoration: BoxDecoration(
                              color: AppColors.logoBluishWhiteColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.height5),
                            ),
                            onTapFunction: () {
                              Clipboard.setData(ClipboardData(
                                  text: _createRoomController.roomId.value));
                              showAppSnackbar(
                                  title: "Copied",
                                  description:
                                      "Room ID Copied Successfully to Clipboard");
                            },
                            child: Icon(
                              Icons.copy,
                              size: Dimensions.height10 * 2,
                              color: AppColors.brightCyanColor,
                            ),
                          ),
                          SizedBox(height: Dimensions.height5),
                          ButtonPressEffectContainer(
                            height: Dimensions.height30,
                            width: Dimensions.height30,
                            decoration: BoxDecoration(
                              color: AppColors.logoBluishWhiteColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.height5),
                            ),
                            onTapFunction: () {
                              Clipboard.setData(ClipboardData(
                                  text: _createRoomController
                                      .roomPassword.value));
                              showAppSnackbar(
                                  title: "Copied",
                                  description:
                                      "Room Password Copied Successfully to Clipboard");
                            },
                            child: Icon(
                              Icons.copy,
                              size: Dimensions.height10 * 2,
                              color: AppColors.brightCyanColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: Dimensions.height5),
                  const Divider(
                    color: Colors.black26,
                    thickness: 1,
                  ),
                  SizedBox(height: Dimensions.height20),
                  const BigText(
                    text: "Room Name",
                    textColor: Colors.black,
                    size: 16,
                  ),
                  SizedBox(height: Dimensions.height20),
                  GetBuilder<CreateRoomController>(builder: (context) {
                    return AppTextField(
                      textEditingController:
                          _createRoomController.roomNameController,
                      hintText: "Your Room Name Here",
                      errorText: _createRoomController.quizNameError,
                    );
                  }),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  const BigText(
                    text: "Quiz Category",
                    textColor: Colors.black,
                    size: 16,
                  ),
                  SizedBox(height: Dimensions.height20),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.responsiveWidth(20),
                          vertical: Dimensions.responsiveHeight(1.5),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.textColor,
                            width: 0.2,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowBlackColor,
                              offset: Offset(1, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: GetBuilder<CreateRoomController>(builder: (_) {
                            return GetBuilder<CategoryController>(
                                builder: (categoryController) {
                              return DropdownButton(
                                underline: const SizedBox(
                                  height: 0,
                                ),
                                menuMaxHeight:
                                    Dimensions.deviceScreenHeight * 0.3,
                                borderRadius: BorderRadius.circular(13),
                                hint: const Text("Select Category"),
                                isExpanded: true,
                                value:
                                    _createRoomController.categoryDropdownValue,
                                items: List.generate(
                                  categoryController
                                      .userDefinedCategoryList.length,
                                  (index) => DropdownMenuItem(
                                    value: categoryController
                                        .userDefinedCategoryList[index].uid,
                                    child: Text(categoryController
                                        .userDefinedCategoryList[index].name),
                                  ),
                                ),
                                onChanged: (value) {
                                  _createRoomController
                                      .updateCategoryDropdownValue(value);
                                  _createRoomController
                                      .isRoomDetailsFormValid();
                                  _createRoomController.setQuizList(
                                    categoryId: _createRoomController
                                        .categoryDropdownValue
                                        .toString(),
                                  );
                                },
                              );
                            });
                          }),
                        ),
                      ),
                      _createRoomController.categoryError == null
                          ? const SizedBox(
                              height: 0,
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: Dimensions.height10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      text:
                                          _createRoomController.categoryError!,
                                      textColor: Colors.red,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  const BigText(
                    text: "Quiz",
                    textColor: Colors.black,
                    size: 16,
                  ),
                  SizedBox(height: Dimensions.height20),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.responsiveWidth(20),
                          vertical: Dimensions.responsiveHeight(1.5),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.textColor,
                            width: 0.2,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowBlackColor,
                              offset: Offset(1, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: GetBuilder<CreateRoomController>(
                              builder: (createRoomController) {
                            return GetBuilder<QuizListController>(
                                builder: (quizListController) {
                              return quizListController.isDataReadyForDropDown
                                  ? DropdownButton(
                                      underline: const SizedBox(
                                        height: 0,
                                      ),
                                      menuMaxHeight:
                                          Dimensions.deviceScreenHeight * 0.3,
                                      borderRadius: BorderRadius.circular(13),
                                      hint: const Text("Select Quiz"),
                                      isExpanded: true,
                                      value: _createRoomController
                                          .quizDropdownValue,
                                      items: List.generate(
                                        quizListController.quizList.length,
                                        (index) => DropdownMenuItem(
                                          value: createRoomController
                                              .quizList[index].quizId,
                                          child: Text(createRoomController
                                              .quizList[index].quizName),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        String id = value.toString();
                                        _createRoomController
                                            .updateQuizDropdownValue(value);
                                        _createRoomController
                                            .isRoomDetailsFormValid();
                                        _createRoomController
                                            .updateRoomPassword(
                                                quizListController.quizList
                                                    .firstWhere((element) {
                                          return (element.quizId == id);
                                        }).quizPassword);
                                      },
                                    )
                                  : SizedBox(
                                      height: Dimensions.height50,
                                      width: double.maxFinite,
                                      child: Center(
                                        child: quizListController
                                                .isDataAvailable
                                            ? const CircularProgressIndicator()
                                            : Builder(builder: (context) {
                                                _createRoomController
                                                    .noQuizHandler();

                                                return const CustomText(
                                                  text: "No Quiz Found",
                                                  textColor: Colors.black,
                                                  size: 16,
                                                );
                                              }),
                                        //power execution
                                      ),
                                    );
                            });
                          }),
                        ),
                      ),
                      _createRoomController.quizError == null
                          ? const SizedBox(
                              height: 0,
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: Dimensions.height10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      text: _createRoomController.quizError!,
                                      textColor: Colors.red,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height50),
                  ButtonPressEffectContainer(
                    onTapFunction: () async {
                      bool isValid =
                          _createRoomController.isRoomDetailsFormValid();
                      setState(
                          () {}); //!for some reason state wasn't updating to show error, so explicitly updating the state to show errors
                      if (isValid) {
                        showProgressIndicatorDialog();
                        bool result =
                            await _createRoomController.addQuizToDatabase();
                        Navigator.of(Get.context!).pop();
                        if (result) {
                          Get.find<RoomController>().getRoomList();
                          Get.back();
                          showAppSnackbar(
                              title: "Success", description: "Room Created");
                        } else {
                          showAppSnackbar(
                              title: "Error",
                              description: "Something went wrong");
                        }
                      }
                    },
                    height: 60,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
