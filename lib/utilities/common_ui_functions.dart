import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/big_text.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/empty_custom_dialog.dart';
import 'app_colors.dart';

void showProgressIndicatorDialog() {
  showDialog(
    context: Get.context!,
    builder: (context) => const EmptyCustomDialog(
      child: CircularProgressIndicator(
        color: AppColors.mainBlueColor,
      ),
    ),
  );
}

Future<bool> showAlertDialog({
  required String title,
  required String description,
  required String buttonText1,
  required String buttonText2,
  Function()? onPressed1,
  Function()? onPressed2,
}) async {
  bool? exitStatus = await showDialog(
    context: Get.context!,
    builder: (context) => CustomDialog(
      iconData: Icons.exit_to_app,
      title: title,
      descriptionText: description,
      actionWidgets: [
        InkWell(
          onTap: () {
            onPressed1 == null
                ? Navigator.of(context).pop(false)
                : onPressed1();
          },
          child: BigText(
            text: buttonText1,
            textColor: AppColors.mainBlueColor,
            size: 20,
          ),
        ),
        InkWell(
          onTap: () {
            onPressed2 == null ? Navigator.of(context).pop(true) : onPressed2();
          },
          child: BigText(
            text: buttonText2,
            textColor: Colors.red,
            size: 20,
          ),
        ),
      ],
    ),
  );
  return (exitStatus == null) ? false : exitStatus;
}

Future<void> showErrorDialog({
  required String description,
  String userActionButtonName = "OK",
  Function()? onPressed,
}) async {
  Navigator.of(Get.context!).pop();
  await showDialog(
    context: Get.context!,
    builder: (context) {
      return CustomDialog(
        iconData: Icons.error,
        iconColor: Colors.red,
        title: "Error",
        titleColor: Colors.red,
        descriptionText: description,
        actionWidgets: [
          TextButton(
            onPressed: (onPressed == null)
                ? () => Navigator.of(context).pop()
                : onPressed,
            child: BigText(
              text: userActionButtonName,
              textColor: AppColors.mainBlueColor,
              size: 18,
            ),
          ),
        ],
      );
    },
  );
}

void showAppSnackbar({required String title, required String description}) {
  Get.snackbar(
    title,
    description,
    colorText: AppColors.mainBlueColor,
    backgroundColor: Colors.white,
    duration: const Duration(seconds: 2),
  );
}
