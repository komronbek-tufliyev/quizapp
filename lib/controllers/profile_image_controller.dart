import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:quizapp/utilities/app_constants.dart';
import 'package:quizapp/utilities/common_ui_functions.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';
import 'package:quizapp/utilities/image_functions.dart';

// import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageController extends GetxController {
  //to store the compressed image data
  File? compressedFileToUpload;

  //Reference to the firebase storage image-storing folder(profileImage) along with the user id as the name of the file
  late Reference firebaseStorageImageRef;

  //Provides the image url of the image stored in device storage
  RxString profileImageUrl = "".obs;

  //This method will be called to set the image reference to firebase once the usermodel is loaded
  void setProfileImageReference(String uid) {
    firebaseStorageImageRef =
        FirebaseStorage.instance.ref().child("profileImages").child(uid);
    // .child(userController.userModel!.uid);
  }

  void setProfileImageUrl() async {
    try {
      profileImageUrl.value = await firebaseStorageImageRef.getDownloadURL();
    } catch (e) {
      profileImageUrl.value = "";
    }
  }

  void pickImage() async {
    compressedFileToUpload = await ImageFunctions.pickImage();
    showProgressIndicatorDialog();
    if (compressedFileToUpload != null) {
      if (await FirebaseCommonFunctions.uploadImageToFirebase(
          firebaseStorageImageRef: firebaseStorageImageRef,
          fileToUpload: compressedFileToUpload!)) {
        // await saveCompressedFileLoacally();
        setProfileImageUrl();
        showAppSnackbar(
          title: "Success",
          description: "Profile Image Updated Successfully",
        );
      }
    }
    Navigator.of(Get.context!).pop();
  }
}
