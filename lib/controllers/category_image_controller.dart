import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/utilities/image_functions.dart';

// import 'package:shared_preferences/shared_preferences.dart';

class CategoryImageController extends GetxController {
  final UserController userController = Get.find();
  //to store the compressed image data
  File? compressedFileToUpload;

  //Reference to the firebase storage image-storing folder(profileImage) along with the user id as the name of the file
  late Reference firebaseStorageImageRef;

  //Provides the image url of the image stored in device storage
  RxString categoryImageUrl = "".obs;

  RxBool hasImage = false.obs;

  //This method will be called to set the image reference to firebase once the usermodel is loaded
  void setCategoryImageReference(String uid) {
    firebaseStorageImageRef =
        FirebaseStorage.instance.ref().child("categoryImages").child(uid);
    // .child(userController.userModel!.uid);
  }

  void setCategoryImageUrl() async {
    try {
      categoryImageUrl.value = await firebaseStorageImageRef.getDownloadURL();
    } catch (e) {
      categoryImageUrl.value = "";
    }
  }

  void pickImage() async {
    hasImage.value = false;
    compressedFileToUpload = null;
    setCategoryImageReference(Get.find<UserController>().userModel!.uid);
    compressedFileToUpload = await ImageFunctions.pickImage();
    if (compressedFileToUpload != null) {
      hasImage.value = true;
    }
  }
}
