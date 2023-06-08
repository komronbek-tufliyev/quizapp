import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/room_controller.dart';
import 'package:quizapp/controllers/user_controller.dart';
import 'package:quizapp/models/category_model.dart';
import 'package:quizapp/models/room_model.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';

import '../utilities/common_ui_functions.dart';

class CategoryController extends GetxController {
  final UserController userController = Get.find();
  final RoomController roomController = Get.find();
  final List<CategoryModel> preDefinedCategoryList = [];
  final List<CategoryModel> userDefinedCategoryList = [];
  final List<String> preDefinedCategoryImageUrlList = [];
  final List<String> userDefinedCategoryImageUrlList = [];

  Future<void> createCategory(String name, File? imageFile) async {
    //only create category if user data has been loaded. else exception will be thrown as the created category will not have a uid.

    showProgressIndicatorDialog();
    //if user data has been loaded, create category model from the data
    CategoryModel categoryModel = CategoryModel(
        uid: userController.userModel!.uid,
        name: name,
        displayImage: false,
        createdAt: Timestamp.now(),
        categoryList: []);
    //add category to firebase and get the document reference
    var result = await FirebaseCommonFunctions.addDocumentToCollection(
        collectionReference: FirebaseFirestore.instance.collection(
            "categories/${userController.userModel!.uid}/categoryList"),
        // collectionReference:
        //     FirebaseFirestore.instance.collection("preDefinedCategories"),
        data: categoryModel.toJson());
    // upload Image to firebase
    //if document reference is null, show error dialog
    if (result == null) {
      showProgressIndicatorDialog();
      await showErrorDialog(
          description: "Error creating category. Please try again later.");
      return;
    } else {
      await FirebaseCommonFunctions.updateDocumentInCollection(
          collectionReference: FirebaseFirestore.instance.collection(
              "categories/${userController.userModel!.uid}/categoryList"),
          // collectionReference:
          //     FirebaseFirestore.instance.collection("preDefinedCategories"),
          documentId: result.id,
          data: {"id": result.id});
      //if image file is not null, upload image to firebase
      if (imageFile != null) {
        if (await FirebaseCommonFunctions.uploadImageToFirebase(
            firebaseStorageImageRef: FirebaseStorage.instance.ref(
                "categoryImages/${userController.userModel!.uid}/${result.id}"),
            // firebaseStorageImageRef: FirebaseStorage.instance
            //     .ref("preDefinedCategoriesImages/${result.id}"),
            fileToUpload: imageFile)) {
          await FirebaseCommonFunctions.updateDocumentInCollection(
              collectionReference: FirebaseFirestore.instance.collection(
                  "categories/${userController.userModel!.uid}/categoryList"),
              // collectionReference:
              //     FirebaseFirestore.instance.collection("preDefinedCategories"),
              documentId: result.id,
              data: {"displayImage": true});
        }
      }
      Navigator.of(Get.context!).pop();
    }
  }

  void getPreDefinedCategoriesListAndImageUrls() async {
    preDefinedCategoryList.clear();
    preDefinedCategoryImageUrlList.clear();
    var docList = await FirebaseCommonFunctions.getDocList(
        collectionReference: FirebaseFirestore.instance
            .collection("categories/sLAE3g5DqLUt3sZR4ZdZFT2nTRo1/categoryList"),
        isDescending: true);
    for (int i = 0; i < docList.length; i++) {
      await buildPreDefinedCategoryList(CategoryModel.fromJson(
        docList[i].data() as Map<String, dynamic>,
      ));
    }
  }

  void getUserDefinedCategoriesListAndImageUrls() async {
    userDefinedCategoryList.clear();
    userDefinedCategoryImageUrlList.clear();
    var docList = await FirebaseCommonFunctions.getDocList(
        collectionReference: FirebaseFirestore.instance.collection(
            "categories/${userController.userModel!.uid}/categoryList"),
        isDescending: true);
    for (int i = 0; i < docList.length; i++) {
      await buildUserDefinedCategoryList(CategoryModel.fromJson(
        docList[i].data() as Map<String, dynamic>,
      ));
    }
    update();
  }

  Future<void> buildPreDefinedCategoryList(
      CategoryModel categoryElement) async {
    String url = categoryElement.displayImage == true
        ? await FirebaseStorage.instance
            .ref()
            .child("categoryImages/sLAE3g5DqLUt3sZR4ZdZFT2nTRo1")
            .child(categoryElement.uid)
            .getDownloadURL()
        : "";
    preDefinedCategoryList.add(
      categoryElement,
    );
    preDefinedCategoryImageUrlList.add(url);
    update();
  }

  Future<void> buildUserDefinedCategoryList(
      CategoryModel categoryElement) async {
    String url = categoryElement.displayImage == true
        ? await FirebaseStorage.instance
            .ref()
            .child("categoryImages")
            .child(userController.userModel!.uid)
            .child(categoryElement.uid)
            .getDownloadURL()
        : "";
    userDefinedCategoryList.add(
      categoryElement,
    );
    userDefinedCategoryImageUrlList.add(url);
    print("Here i am");
    update();
  }

  Future<bool> deleteCategory({required String categoryID}) async {
    showProgressIndicatorDialog();
    await roomController.getRoomList();
    List<RoomModel> roomList = roomController.roomList;
    for (var room in roomList) {
      if (room.categoryId == categoryID) {
        Navigator.of(Get.context!).pop();
        return false;
      }
    }
    await FirebaseCommonFunctions.deleteDocument(
        collectionPath:
            "categories/${userController.userModel!.uid}/categoryList",
        docName: categoryID);
    getUserDefinedCategoriesListAndImageUrls();

    Navigator.of(Get.context!).pop();
    return true;
  }
}
