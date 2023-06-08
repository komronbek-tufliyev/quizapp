import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseCommonFunctions {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference usersCollectionReference =
      firestore.collection('users');

  //checking ig a document exists in a collection
  static Future<bool> checkIfDocumentExists(
      CollectionReference collectionReference, String documentId) async {
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(documentId).get();
    return documentSnapshot.exists;
  }

  //to upload the image to firebase storage.
  static Future<bool> uploadImageToFirebase(
      {required Reference firebaseStorageImageRef,
      required File fileToUpload}) async {
    try {
      await firebaseStorageImageRef.putFile(File(fileToUpload.path));
      return true;
    } catch (e) {
      return false;
    }
  }

  //adding a document to a collection
  static Future<DocumentReference?> addDocumentToCollection(
      {required CollectionReference collectionReference,
      required Map<String, dynamic> data}) async {
    try {
      DocumentReference? result;
      result = await collectionReference
          .add(data)
          .timeout(const Duration(seconds: 5));
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> addDocumentWithNameToCollection(
      {required CollectionReference collectionReference,
      required String documentName,
      required Map<String, dynamic> data}) async {
    try {
      await collectionReference
          .doc(documentName)
          .set(data)
          .timeout(const Duration(seconds: 10));
      return true;
    } catch (e) {
      return false;
    }
  }

  //updating a document in a collection
  static Future updateDocumentInCollection(
      {required CollectionReference collectionReference,
      required String documentId,
      required Map<String, dynamic> data}) async {
    try {
      await collectionReference.doc(documentId).update(data).timeout(
            const Duration(seconds: 5),
          );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<DocumentSnapshot>> getDocList({
    required CollectionReference collectionReference,
    required bool isDescending,
  }) async {
    List<DocumentSnapshot> docList = [];
    try {
      await collectionReference
          .orderBy('createdAt', descending: isDescending)
          .get()
          .then((value) {
        for (var element in value.docs) {
          docList.add(element);
        }
      });
      return docList;
    } catch (e) {
      return [];
    }
  }

  static Future<List<DocumentSnapshot>> getDocListWithOrderBy({
    required CollectionReference collectionReference,
    required bool isDescending,
    required String orderBy,
  }) async {
    List<DocumentSnapshot> docList = [];
    try {
      await collectionReference
          .orderBy(orderBy, descending: isDescending)
          .get()
          .then((value) {
        for (var element in value.docs) {
          docList.add(element);
        }
      });
      return docList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //get document from a collection
  static Future<DocumentSnapshot?> getDocumentFromCollection(
      {required CollectionReference collectionReference,
      required String documentId}) async {
    try {
      DocumentSnapshot? documentSnapshot =
          await collectionReference.doc(documentId).get();
      return documentSnapshot;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteDocument(
      {required String collectionPath, required String docName}) async {
    try {
      FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(docName)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
