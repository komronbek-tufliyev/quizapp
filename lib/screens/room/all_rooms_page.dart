import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/room_controller.dart';
import 'package:quizapp/models/room_model.dart';
import 'package:quizapp/screens/room/room_detail_page.dart';

import '../../routes/route_helper.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/effects/button_press_effect_container.dart';
import '../../widgets/page_model.dart';

class AllRoomsPage extends StatelessWidget {
  final RoomController _roomController = Get.find();
  AllRoomsPage({super.key}) {
    _roomController.getRoomList();
  }

  @override
  Widget build(BuildContext context) {
    return PageModel(
      onTapFunction: () {
        Get.back();
      },
      title: "Rooms",
      child: GetBuilder<RoomController>(builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BigText(
              text: "Your Rooms",
              textColor: AppColors.titleTextColor,
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _roomController.getRoomList();
                },
                child: LayoutBuilder(builder: (context, constriants) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: SizedBox(
                      height: constriants.maxHeight,
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: Dimensions.height10),
                        crossAxisCount: 2,
                        crossAxisSpacing: Dimensions.height20,
                        mainAxisSpacing: Dimensions.height20,
                        children: [
                          ButtonPressEffectContainer(
                            onTapFunction: () {
                              Get.toNamed(RouteHelper.getNewRoomPage());
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
                                  text: "Room",
                                  size: 20,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.textColor,
                                ),
                              ],
                            ),
                          ),
                          ...List.generate(
                            _roomController.roomList.length,
                            (index) => _buildGridViewContainer(
                              index,
                              _roomController.roomList[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildGridViewContainer(int index, RoomModel roomModel) {
    index = index % 4;
    return ButtonPressEffectContainer(
      onTapFunction: () {
        // Get.toNamed("alsjdflajsd", arguments: categoryModel);
        Get.to(
          () => RoomDetailPage(
            roomModel: roomModel,
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
                      text: roomModel.roomName,
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
            child: CircleAvatar(
              radius: Dimensions.deviceScreenWidth * 0.3 / 1.3 / 2,
              backgroundColor: AppColors.gridTextColors[index],
              child: CustomText(
                text: roomModel.roomName.substring(0, 1),
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
