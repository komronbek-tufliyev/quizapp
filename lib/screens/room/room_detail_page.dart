import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/room_controller.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/widgets/effects/button_press_effect_container.dart';
import 'package:quizapp/widgets/page_model.dart';

import '../../models/room_model.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';

class RoomDetailPage extends StatelessWidget {
  final RoomModel roomModel;
  final RoomController roomController = Get.find();
  RoomDetailPage({super.key, required this.roomModel});

  @override
  Widget build(BuildContext context) {
    return PageModel(
      onTapFunction: () {
        Get.back();
      },
      title: "Room : ${roomModel.roomName}",
      child: Stack(
        children: [
          Column(
            children: [
              const BigText(
                text: "Room Detail",
                textColor: AppColors.titleTextColor,
              ),
              SizedBox(
                height: Dimensions.height20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: BigText(
                          text: "Room Name:",
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomText(
                          text: roomModel.roomName,
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: BigText(
                          text: "Room ID:",
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomText(
                          text: roomModel.roomId,
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: BigText(
                          text: "Room/Quiz Password:",
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomText(
                          text: roomModel.quizPassword,
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: BigText(
                          text: "Quiz Name:",
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomText(
                          text: roomModel.quizName,
                          textColor: AppColors.titleTextColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                ButtonPressEffectContainer(
                  decoration: BoxDecoration(
                      color: AppColors.mainBlueColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: Dimensions.height50,
                  width: double.maxFinite,
                  onTapFunction: () {
                    Clipboard.setData(ClipboardData(text: roomModel.roomId));
                    showAppSnackbar(
                        title: "Copied",
                        description: "Room ID Copied to Clipboard");
                  },
                  child: const Center(
                    child: BigText(text: "Copy Room ID"),
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                ButtonPressEffectContainer(
                  decoration: BoxDecoration(
                      color: AppColors.mainBlueColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: Dimensions.height50,
                  width: double.maxFinite,
                  onTapFunction: () {
                    Clipboard.setData(
                        ClipboardData(text: roomModel.quizPassword));
                    showAppSnackbar(
                        title: "Copied",
                        description: "Room Password Copied to Clipboard");
                  },
                  child: const Center(
                    child: BigText(text: "Copy Room Password"),
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                ButtonPressEffectContainer(
                  decoration: BoxDecoration(
                      color: AppColors.mainBlueColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: Dimensions.height50,
                  width: double.maxFinite,
                  onTapFunction: () {
                    showAlertDialog(
                      title: "Delete?",
                      description:
                          "All room results and room details will be deleted!",
                      buttonText1: "Cancel",
                      buttonText2: "Continue",
                      onPressed2: () async {
                        Navigator.of(Get.context!).pop();
                        bool deleteSuccess = await roomController.deleteRoom(
                            roomID: roomModel.roomId);
                        if (deleteSuccess) {
                          print("Deletion success");
                          Get.back();
                          showAppSnackbar(
                              title: "Success",
                              description: "Room Deleted Successfully");
                        }
                      },
                    );
                  },
                  child: const Center(
                    child: BigText(text: "Delete room"),
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
