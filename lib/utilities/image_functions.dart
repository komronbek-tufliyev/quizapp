import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/big_text.dart';
import '../widgets/effects/button_press_effect_container.dart';
import 'app_colors.dart';
import 'common_ui_functions.dart';
import 'dimensions.dart';
import 'package:path/path.dart' as path;

class ImageFunctions {
  //to pick the image from the gallery or camera
  static final ImagePicker _imagePicker = ImagePicker();
  static XFile? image; //to store the image picked from the gallery or camera

  //to store the cropped image data
  static CroppedFile? croppedFile;

  //compressed file
  static File? compressedFile;

  //List of titles to be shown in the bottom sheet
  static List<String> titles = [
    'Camera',
    'Gallery',
  ];

  //List of path of the images to be shown in the bottom sheet
  static List<String> imagePath = [
    'assets/images/camera.png',
    'assets/images/gallery.png',
  ];

  // to show the bottom sheet to choose between camera and gallery. It also sets the image variable to the image picked from the gallery or camera. If the user cancels the process, then it sets the image variable to null.
  static Future<void> customShowBottomSheet() async {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      // barrierColor: Colors.transparent,
      context: Get.context!,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BigText(
                text: "Choose Image From",
                size: 20,
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.all(Dimensions.height10),
                margin: EdgeInsets.only(
                    bottom: Dimensions.height20,
                    left: Dimensions.width20,
                    right: Dimensions.width20),
                height: Dimensions.height60 * 1.5,
                decoration: BoxDecoration(
                    color: AppColors.backgroundWhiteColor,
                    borderRadius: BorderRadius.circular(Dimensions.height15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < 2; i++)
                      ButtonPressEffectContainer(
                        height: Dimensions.height60 * 1.5,
                        width: Dimensions.width30 * 3,
                        onTapFunction: () async {
                          if (i == 0) {
                            image = await _imagePicker.pickImage(
                                source: ImageSource.camera);
                          } else {
                            image = await _imagePicker.pickImage(
                                source: ImageSource.gallery);
                          }
                          Get.back();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimensions.height5),
                              height: Dimensions.height40,
                              width: Dimensions.height40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.height10),
                                  border: Border.all(
                                      color: AppColors.mainBlueColor,
                                      width: 2)),
                              child: Image.asset(
                                imagePath[i],
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            BigText(
                              text: titles[i],
                              textColor: AppColors.mainBlueColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //to crop the image. If user cancels the cropping, then croppedFile variable is set to null.
  static Future<void> cropImage() async {
    croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          backgroundColor: Colors.white,
          statusBarColor: AppColors.mainBlueColor,
          toolbarTitle: 'Crop Image - Quiz App',
          toolbarColor: AppColors.mainBlueColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
  }

  //to compress the image. If the image is successfully compressed, then it returns the compressed image. If the image is not compressed, then it returns null.
  static Future<File?> compressImage() async {
    final newPath = path.join((await getTemporaryDirectory()).path,
        "${DateTime.now()}${path.extension(croppedFile!.path)}");
    try {
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        croppedFile!.path,
        newPath,
        quality: 50,
      );
      return compressedImage;
    } catch (e) {
      return null;
    }
  }

  //when user presses the edit image button, it shows the bottom sheet to choose between camera and gallery. It also sets the image variable to the image picked from the gallery or camera. If the user cancels the process, then it sets the image variable to null. If the user selects any image from camera or gallary, then it directs user to crop the image. If user cancels the cropping, then it sets the croppedFile variable to null. If user crops the image, then it compresses the image and uploads it to firebase storage. If the image is successfully uploaded to firebase storage, then it saves the compressed image to the device storage. If the image is successfully saved to the device storage, then it shows a snackbar to the user and sets the profileImageUrl to the path of the image stored in the device storage.
  static Future<File?> pickImage() async {
    image = null;
    croppedFile = null;
    compressedFile = null;
    await customShowBottomSheet();
    if (image != null) {
      await cropImage();
      if (croppedFile != null) {
        showProgressIndicatorDialog();
        compressedFile = await compressImage();
        Navigator.of(Get.context!).pop();
        return compressedFile;
      }
    }
    return null;
  }
}
