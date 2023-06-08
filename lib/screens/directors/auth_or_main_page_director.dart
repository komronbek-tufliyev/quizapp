import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../auth/sign_in_page.dart';
import '../home/main_screen.dart';

class AuthOrMainPageDirector extends StatelessWidget {
  const AuthOrMainPageDirector({super.key});

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? const SignInPage()
        : StreamBuilder(
            stream: Get.find<UserController>().setUserModel(),
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data == false) {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                      // child: ,
                      ),
                );
              } else {
                return const MainScreen();
              }
            },
          );
  }
}
