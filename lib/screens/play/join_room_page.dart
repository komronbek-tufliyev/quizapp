import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/join_room_controller.dart';
import 'package:quizapp/routes/route_helper.dart';
import 'package:quizapp/utilities/app_colors.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/widgets/custom_text.dart';
import 'package:quizapp/widgets/effects/button_press_effect_container.dart';
import 'package:quizapp/widgets/page_model.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  bool showSearchRoom = true;
  final JoinRoomController _joinRoomController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _joinRoomController.validateRoomID();
      },
      child: PageModel(
        onTapFunction: () {
          if (showSearchRoom == false) {
            showAlertDialog(
                title: "Confirm?",
                description: "Cancel Joining quiz?",
                buttonText1: "No",
                buttonText2: "Yes",
                onPressed2: () {
                  Get.back(); //closes alert dialog
                  Get.back(); //closes join room page
                });
          } else {
            Get.back();
          }
        },
        title: "Join Room",
        child: showSearchRoom ? searchRoomWidget() : roomPassword(),
      ),
    );
  }

  Widget searchRoomWidget() {
    return Stack(
      children: [
        Column(
          children: [
            const BigText(
              text: "Room ID",
              textColor: Colors.black,
              size: 20,
            ),
            SizedBox(height: Dimensions.height20),
            GetBuilder<JoinRoomController>(builder: (_) {
              return AppTextField(
                textEditingController: _joinRoomController.roomIdController,
                hintText: "Enter Joining Room ID",
                errorText: _joinRoomController.roomIdErrorText,
              );
            }),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ButtonPressEffectContainer(
            decoration: BoxDecoration(
              color: AppColors.mainBlueColor,
              borderRadius: BorderRadius.circular(15),
            ),
            onTapFunction: () async {
              if (_joinRoomController.validateRoomID()) {
                bool result = await _joinRoomController.searchRoom();
                print(result);
                if (result) {
                  print(result);
                  setState(() {
                    showSearchRoom = false;
                  });
                }
              }
            },
            height: Dimensions.height60,
            width: 0,
            child: const CustomText(text: "Search"),
          ),
        ),
      ],
    );
  }

  Widget roomPassword() {
    _joinRoomController.getOwnerProfileImageUrl();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: BigText(
              text: "Room Found!",
              textColor: Colors.black,
              size: 24,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          const BigText(
            text: "Created By",
            textColor: Colors.black,
            size: 18,
          ),
          SizedBox(height: Dimensions.height10),
          Container(
            height: Dimensions.height60,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.mainBlueColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(Dimensions.height15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: Dimensions.width20 / 2),
                GetBuilder<JoinRoomController>(builder: (_) {
                  return CircleAvatar(
                    radius: Dimensions.height25,
                    backgroundImage:
                        _joinRoomController.ownerProfileImageUrl == null
                            ? null
                            : NetworkImage(
                                _joinRoomController.ownerProfileImageUrl!),
                    backgroundColor: AppColors.mainBlueColor,
                    child: _joinRoomController.ownerProfileImageUrl == null
                        ? BigText(
                            text: _joinRoomController.roomModel!.ownerName[0],
                            size: 20,
                          )
                        : null,
                  );
                }),
                SizedBox(width: Dimensions.width20),
                BigText(
                    text: _joinRoomController.roomModel!.ownerName,
                    size: 20,
                    textColor: Colors.black),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height20),
          const BigText(
            text: "Room and Quiz Details",
            textColor: Colors.black,
            size: 18,
          ),
          SizedBox(height: Dimensions.height20),
          Container(
            decoration: BoxDecoration(
              color: AppColors.mainBlueColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(Dimensions.height15),
            ),
            padding: EdgeInsets.all(Dimensions.height15),
            child: Table(
              children: [
                TableRow(children: [
                  const BigText(
                    text: "Room Name",
                    textColor: Colors.black,
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.height15),
                    child: CustomText(
                      text: _joinRoomController.roomModel!.roomName,
                      textColor: Colors.black,
                      size: 16,
                    ),
                  ),
                ]),
                TableRow(children: [
                  const BigText(
                    text: "Room ID",
                    textColor: Colors.black,
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.height15),
                    child: CustomText(
                      text: _joinRoomController.roomModel!.roomId,
                      textColor: Colors.black,
                      size: 16,
                    ),
                  ),
                ]),
                TableRow(children: [
                  const BigText(
                    text: "Quiz Name",
                    textColor: Colors.black,
                    size: 16,
                  ),
                  CustomText(
                    text: _joinRoomController.roomModel!.quizName,
                    textColor: Colors.black,
                    size: 16,
                  ),
                ]),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height20),
          const BigText(
            text: "Enter Quiz Password",
            textColor: Colors.black,
            size: 20,
          ),
          SizedBox(height: Dimensions.height20),
          GetBuilder<JoinRoomController>(builder: (_) {
            return AppTextField(
              textEditingController: _joinRoomController.roomPasswordController,
              hintText: "Enter Quiz Password",
              errorText: _joinRoomController.roomPasswordErrorText,
            );
          }),
          SizedBox(height: Dimensions.height60),
          ButtonPressEffectContainer(
            decoration: BoxDecoration(
              color: AppColors.mainBlueColor,
              borderRadius: BorderRadius.circular(15),
            ),
            onTapFunction: () {
              if (_joinRoomController.validateRoomPassword()) {
                if (_joinRoomController.roomModel!.quizPassword ==
                    _joinRoomController.roomPasswordController.text.trim()) {
                  Get.offNamed(RouteHelper.getQuizPlayPage(),
                      arguments: [_joinRoomController.roomModel!]);
                } else {
                  showProgressIndicatorDialog();
                  showErrorDialog(description: "Quiz Password is incorrect");
                }
              }
            },
            height: Dimensions.height60,
            width: double.maxFinite,
            child: const CustomText(text: "Join"),
          ),
        ],
      ),
    );
  }
}
