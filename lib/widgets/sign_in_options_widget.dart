import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/auth_controller.dart';
import 'package:quizapp/utilities/app_colors.dart';
import 'package:quizapp/widgets/big_text.dart';

import '../utilities/dimensions.dart';
import 'effects/button_press_effect_container.dart';

class SignInOptionsWidget extends StatelessWidget {
  SignInOptionsWidget({super.key});
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ButtonPressEffectContainer(
      onTapFunction: () async {
        await authController.signInWithGoogle();
      },
      padding: EdgeInsets.all(Dimensions.height10),
      height: Dimensions.height50,
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.height10),
          border: Border.all(color: AppColors.mainBlueColor, width: 2),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, blurRadius: 2, offset: const Offset(1, 2)),
          ],
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: Dimensions.height20,
            backgroundImage: const AssetImage(
              "assets/images/google.png",
            ),
          ),
          SizedBox(width: Dimensions.width15),
          const BigText(
            text: "Google Sign In",
            textColor: Colors.black,
            size: 20,
          ),
        ],
      ),
    );
  }

  List<BoxShadow> iconBoxShadow() {
    return [
      BoxShadow(
        color: Colors.grey,
        blurRadius: Dimensions.height5,
        offset: const Offset(1, 2),
      ),
    ]; // changes position of shadow
  }
}
