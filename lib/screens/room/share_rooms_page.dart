import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/quiz_list_controller.dart';
import 'package:quizapp/controllers/room_controller.dart';
import 'package:quizapp/models/category_model.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/models/room_model.dart';
import 'package:quizapp/widgets/page_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/effects/button_press_effect_container.dart';

class ShareRoomsPage extends StatelessWidget {
  final RoomController roomController = Get.find();
  ShareRoomsPage({
    super.key,
  }) {
    roomController.getRoomList();
  }

  @override
  Widget build(BuildContext context) {
    return PageModel(
      onTapFunction: () {
        Get.back();
      },
      title: "Your Rooms",
      child: GetBuilder<RoomController>(
        builder: (_) {
          return roomController.isRoomDataReady
              ? roomController.roomList.isEmpty
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
                      itemCount: roomController.roomList.length,
                      itemBuilder: (context, index) {
                        return buildRoomItem(
                          index: index + 1,
                          roomModel: roomController.roomList[index],
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
    );
  }

  Widget buildRoomItem({
    required int index,
    required RoomModel roomModel,
  }) {
    return Container(
      width: Dimensions.deviceScreenWidth * 0.6,
      height: Dimensions.height60,
      margin: EdgeInsets.symmetric(vertical: Dimensions.height5),
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: BigText(
                  text: '$index    ${roomModel.roomName}',
                  textColor: AppColors.textColor,
                  size: 18,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    ButtonPressEffectContainer(
                      padding: EdgeInsets.zero,
                      height: Dimensions.height40,
                      width: Dimensions.height40 * 2,
                      onTapFunction: () {
                        Share.share(
                            "RoomName: ${roomModel.roomName} \nRoom ID: ${roomModel.roomId}, \nRoom Password: ${roomModel.quizPassword}");
                      },
                      decoration: BoxDecoration(
                          color: AppColors.mainBlueColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.height10)),
                      child: const BigText(
                        text: "Share",
                        size: 20,
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
