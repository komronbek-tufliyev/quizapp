import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizapp/routes/route_helper.dart';
import 'package:quizapp/utilities/firebase_common_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/common_ui_functions.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SharedPreferences sharedPreferences = Get.find();

  //save userdata to database
  Future<bool> saveUserDataToDatabase(
      {required String name,
      required String email,
      required String uid}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({
        'name': name,
        'email': email,
        'uid': _auth.currentUser!.uid,
      });
      return true;
    } catch (e) {
      showErrorDialog(description: e.toString());
      return false;
    }
  }

  //* Sign in and Sign up with email and password
  Future signIn(String email, String password) async {
    showProgressIndicatorDialog();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorDialog(description: 'No user found for that email.');
        return;
      } else if (e.code == 'network-request-failed') {
        showErrorDialog(description: "Please check your internet connection");
      } else if (e.code == 'wrong-password') {
        showErrorDialog(description: 'Wrong password provided for that user.');
        return;
      } else {
        showErrorDialog(description: e.code);
        return;
      }
    } catch (e) {
      showErrorDialog(description: "Something went wrong");
      return;
    }
    //Popinng the circular progress indicator dialog before navigating to the main page
    // bool result = await saveUserDataInMemory();

    Navigator.of(Get.context!).pop();
    //Navigating to the main page if everything is set
    Get.offAllNamed(RouteHelper.getAuthOrMainPageDirector());
    // if (result) {
    // }
  }

  Future signUp(
      {required String email,
      required String password,
      required String name}) async {
    showProgressIndicatorDialog();
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorDialog(description: "Password is too weak");
      } else if (e.code == 'email-already-in-use') {
        showErrorDialog(
            description: 'The account already exists for that email.');
      } else if (e.code == 'network-request-failed') {
        showErrorDialog(description: "Please check your internet connection");
      } else {
        showErrorDialog(description: e.code);
      }
      return;
    } catch (e) {
      showErrorDialog(description: "Something went wrong");
      return;
    }

    //Save user data to the database
    await saveUserDataToDatabase(
      name: name,
      email: email,
      uid: _auth.currentUser!.uid,
    );

    // bool result = await saveUserDataInMemory();

    //Popinng the circular progress indicator dialog before navigating to the main page
    Navigator.of(Get.context!).pop();
    //Navigating to the main page if everything is set
    Get.offAllNamed(RouteHelper.getAuthOrMainPageDirector());
    // if (result) {
    // }
  }

  //* Sign in with Google
  Future signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount;
    UserCredential? userCredential;
    googleSignInAccount = await _googleSignIn.signIn().catchError((error) {
      return null;
    }); //this catch error doesnt work in debug mode but works in release mode so it will cause no issue later.

    if (googleSignInAccount != null) {
      showProgressIndicatorDialog();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        userCredential = await _auth.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          showErrorDialog(
              description:
                  'The account already exists with a different credential.');
          return;
        } else if (e.code == 'invalid-credential') {
          showErrorDialog(
              description:
                  'Error occurred while accessing credentials. Try again.');
          return;
        }
      } catch (e) {
        showErrorDialog(description: e.toString());
        return;
      }

      if (userCredential != null) {
        //Save user data to the database
        bool docExists = await FirebaseCommonFunctions.checkIfDocumentExists(
            FirebaseCommonFunctions.usersCollectionReference,
            _auth.currentUser!.uid);
        if (!docExists) {
          await saveUserDataToDatabase(
            name: userCredential.user!.displayName!,
            email: userCredential.user!.email!,
            uid: _auth.currentUser!.uid,
          );
        }
      }
    } else {
      return;
    }

    //Popinng the circular progress indicator dialog before navigating to the main page
    Navigator.of(Get.context!).pop();
    //Navigating to the main page if everything is set
    Get.offAllNamed(RouteHelper.getAuthOrMainPageDirector());
    // if (result) {}
  }

  // //* Sign in with Microsoft
  // Future signInWithMicrosoft() async {
  //   MicrosoftAuthProvider provider = MicrosoftAuthProvider();
  //   provider.addScope('user.read');
  //   provider.addScope('profile');
  //   UserCredential? userCredential;
  //   showProgressIndicatorDialog();
  //   try {
  //     userCredential = await _auth.signInWithProvider(provider);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'account-exists-with-different-credential') {
  //       showErrorDialog(
  //           description:
  //               'The account already exists with a different credential.');
  //       return;
  //     } else if (e.code == 'invalid-credential') {
  //       showErrorDialog(
  //           description:
  //               'Error occurred while accessing credentials. Try again.');
  //       return;
  //     } else if (e.code == 'web-context-canceled') {
  //       showErrorDialog(description: "Your Sign in process was canceled");
  //       return;
  //     } else {
  //       showErrorDialog(description: e.code);
  //       return;
  //     }
  //   } catch (e) {
  //     showErrorDialog(description: e.toString());
  //     return;
  //   }

  //   //Save user data to the database
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .set({
  //       'name': userCredential.user!.displayName,
  //       'email': userCredential.user!.email,
  //       'uid': userCredential.user!.uid,
  //     });
  //   } catch (e) {
  //     showErrorDialog(description: e.toString());
  //     return;
  //   }

  //   bool result = await saveUserDataInMemory();

  //   if (result) {
  //     //Popinng the circular progress indicator dialog before navigating to the main page
  //     Navigator.of(Get.context!).pop();
  //     //Navigating to the main page if everything is set
  //     Get.offAllNamed(RouteHelper.getMainPage());
  //   }
  // }

  //* Sign in with Facebook
  // Future signInWithFacebook() async {
  //   LoginResult loginResult;
  //   UserCredential? userCredential;
  //   showProgressIndicatorDialog();
  //   try {
  //     loginResult = await FacebookAuth.instance.login();
  //   } catch (e) {
  //     showErrorDialog(description: e.toString());
  //     return;
  //   }

  //   if (loginResult.status == LoginStatus.success) {
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //     try {
  //       userCredential =
  //           await _auth.signInWithCredential(facebookAuthCredential);
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'account-exists-with-different-credential') {
  //         showErrorDialog(
  //             description:
  //                 'The account already exists with a different credential. May be you have already signed in with Google or Microsoft.');
  //         return;
  //       } else if (e.code == 'invalid-credential') {
  //         showErrorDialog(
  //             description:
  //                 'Error occurred while accessing credentials. Try again.');
  //         return;
  //       } else if (e.code == 'web-context-canceled') {
  //         showErrorDialog(description: "Your Sign in process was canceled");
  //         return;
  //       } else {
  //         showErrorDialog(description: e.code);
  //         return;
  //       }
  //     } catch (e) {
  //       showErrorDialog(description: e.toString());
  //       return;
  //     }
  //   } else {
  //     showErrorDialog(description: "Something went wrong");
  //     return;
  //   }

  //   //Save user data to the database
  //   bool docExists = await FirebaseCommonFunctions.checkIfDocumentExists(
  //       FirebaseCommonFunctions.usersCollectionReference,
  //       _auth.currentUser!.uid);
  //   if (!docExists) {
  //     await saveUserDataToDatabase(
  //       name: userCredential.user!.displayName!,
  //       email: userCredential.user!.email!,
  //       uid: _auth.currentUser!.uid,
  //     );
  //   }

  //   // bool result = await saveUserDataInMemory();

  //   //Popinng the circular progress indicator dialog before navigating to the main page
  //   Navigator.of(Get.context!).pop();
  //   //Navigating to the main page if everything is set
  //   Get.offAllNamed(RouteHelper.getAuthOrMainPageDirector());
  //   // if (result) {}
  // }

  //* Forgot password
  Future forgotPassword({required String email}) async {
    try {
      showProgressIndicatorDialog();
      FocusScope.of(Get.context!).unfocus();
      await _auth.sendPasswordResetEmail(email: email);
      showAppSnackbar(
        title: "Password reset link sent",
        description: "Please check your email",
      );
      Navigator.of(Get.context!).pop();
      //remove the focus from text controller
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorDialog(description: 'No user found for that email.');
      } else if (e.code == 'invalid-email') {
        showErrorDialog(
            description: 'Your email address appears to be malformed.');
      } else {
        showErrorDialog(description: e.code);
      }
    } catch (e) {
      showErrorDialog(description: e.toString());
    }
  }

  //* Sign out

  Future signOut() async {
    // Get.find<ProfileImageController>().deleteProfileImageFromLocalStorage();
    await _auth.signOut();
    await FacebookAuth.instance.logOut();
    await _googleSignIn.signOut();
    // !removing the user data from the memory
    // sharedPreferences.remove(AppConstants.userDataKey);
    Get.offAllNamed(RouteHelper.getSignInPage());
  }
}
