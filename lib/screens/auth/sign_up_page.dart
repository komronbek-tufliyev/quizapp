import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/auth_controller.dart';
import 'package:quizapp/routes/route_helper.dart';
import 'package:quizapp/utilities/app_constants.dart';
import 'package:quizapp/widgets/effects/button_press_effect_container.dart';
import 'package:quizapp/widgets/exit_enabled_widget.dart';
import 'package:quizapp/widgets/sign_in_options_widget.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? emailError, passwordError, confirmPasswordError, nameError;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  AuthController authController = Get.find();

  bool isFormValid() {
    bool isEmailValid = false;
    bool isPasswordValid = false;
    bool isNameValid = false;
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = "This field is required";
      });
    } else if (nameController.text.length <= 2) {
      setState(() {
        nameError = "Name must be at least 3 characters";
      });
    } else {
      setState(() {
        nameError = null;
      });
      isNameValid = true;
    }
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "This field is required";
      });
    } else {
      if (emailController.text.contains("@") &&
          emailController.text.contains(".")) {
        setState(() {
          emailError = null;
        });
        isEmailValid = true;
      } else {
        setState(() {
          emailError = "Invalid Email Format";
        });
      }
    }

    if (passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (passwordController.text == confirmPasswordController.text &&
          passwordController.text.length >=
              AppConstants.minimumPasswordLength &&
          confirmPasswordController.text.length >=
              AppConstants.minimumPasswordLength) {
        setState(() {
          confirmPasswordError = null;
          passwordError = null;
        });
        isPasswordValid = true;
      } else {
        setState(() {
          confirmPasswordError = "Password doesn't match";
        });
      }
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "This field is required";
      });
    } else if (passwordController.text.length <
        AppConstants.minimumPasswordLength) {
      setState(() {
        passwordError =
            "Password must be at least ${AppConstants.minimumPasswordLength} characters";
      });
    } else {
      setState(() {
        passwordError = null;
      });
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        confirmPasswordError = "This field is required";
      });
    } else if (confirmPasswordController.text.length <
        AppConstants.minimumPasswordLength) {
      setState(() {
        confirmPasswordError =
            "Password must be at least ${AppConstants.minimumPasswordLength} characters";
      });
    }

    if (isEmailValid && isPasswordValid && isNameValid) {
      return true;
    } else {
      return false;
    }
  }

  //dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExitEnabledWidget(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: Dimensions.height20 +
                      Dimensions.height200 +
                      Dimensions.statusBarHeight,
                ),
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  right: Dimensions.width20,
                  left: Dimensions.width20,
                  top: Dimensions.height20 * 1.5,
                ),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: []),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          fontWeight: FontWeight.w500,
                          text: "Full Name",
                          textColor: Colors.black,
                          size: 16,
                        ),
                        SizedBox(height: Dimensions.height10),
                        AppTextField(
                          textEditingController: nameController,
                          prefixIcon: Icons.person,
                          hintText: "Your Name",
                          errorText: nameError,
                        ),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        const CustomText(
                          fontWeight: FontWeight.w500,
                          text: "Email",
                          textColor: Colors.black,
                          size: 16,
                        ),
                        SizedBox(height: Dimensions.height10),
                        AppTextField(
                          textEditingController: emailController,
                          prefixIcon: Icons.email_outlined,
                          hintText: "ABCXYZ@gmail.com",
                          errorText: emailError,
                        ),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        const CustomText(
                          fontWeight: FontWeight.w500,
                          text: "Password",
                          textColor: Colors.black,
                          size: 16,
                        ),
                        SizedBox(height: Dimensions.height10),
                        AppTextField(
                          textEditingController: passwordController,
                          prefixIcon: Icons.lock_outline,
                          hintText: "Password",
                          errorText: passwordError,
                          hasHideButton: true,
                        ),
                        SizedBox(height: Dimensions.height20),
                        const CustomText(
                          fontWeight: FontWeight.w500,
                          text: "Confirm Password",
                          textColor: Colors.black,
                          size: 16,
                        ),
                        SizedBox(height: Dimensions.height10),
                        AppTextField(
                          textEditingController: confirmPasswordController,
                          prefixIcon: Icons.lock_outline,
                          hintText: "Re-type Password",
                          errorText: confirmPasswordError,
                          hasHideButton: true,
                        ),
                        SizedBox(height: Dimensions.height30),
                        ButtonPressEffectContainer(
                          margin: EdgeInsets.only(
                            bottom: Dimensions.height10,
                          ),
                          onTapFunction: () async {
                            if (isFormValid()) {
                              await authController.signUp(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                              );
                            }
                          },
                          decoration: BoxDecoration(
                            color: AppColors.mainBlueColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: Dimensions.height60,
                          width: double.maxFinite,
                          child: const Center(
                            child: CustomText(
                              text: "Sign Up",
                            ),
                          ),
                        ),
                        const Center(
                          child: CustomText(
                            text: "Sign In With",
                            textColor: AppColors.mainBlueColor,
                            size: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: Dimensions.height10),
                        SignInOptionsWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.deviceScreenHeight * 0.34,
                child: Stack(
                  children: [
                    Positioned(
                      top: Dimensions.height20 * 2,
                      left: Dimensions.width30 * 2,
                      right: Dimensions.width30 * 2,
                      child: Container(
                        height: Dimensions.responsiveHeight(200) +
                            Dimensions.statusBarHeight,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.lightestBlueColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              Dimensions.width20,
                            ),
                            bottomRight: Radius.circular(
                              Dimensions.width20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: Dimensions.height20,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      child: Container(
                        height: Dimensions.responsiveHeight(200) +
                            Dimensions.statusBarHeight,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              Dimensions.width20,
                            ),
                            bottomRight: Radius.circular(
                              Dimensions.width20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: Dimensions.responsiveHeight(200) +
                          Dimensions.statusBarHeight,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppColors.mainBlueColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            Dimensions.width20,
                          ),
                          bottomRight: Radius.circular(
                            Dimensions.width20,
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          //top left Small Circle Design
                          Positioned(
                            top: -Dimensions.height50,
                            left: -Dimensions.width15,
                            child: CircleAvatar(
                              backgroundColor: AppColors.lowOpacityWhiteColor,
                              radius: Dimensions.responsiveHeight(50),
                              child: CircleAvatar(
                                backgroundColor: AppColors.mainBlueColor,
                                radius: Dimensions.responsiveHeight(25),
                              ),
                            ),
                          ),
                          //Right  Circle Design
                          Positioned(
                            top: Dimensions.height30,
                            right: -Dimensions.width40 * 3.5,
                            child: CircleAvatar(
                              backgroundColor: AppColors.lowOpacityWhiteColor,
                              radius: Dimensions.responsiveHeight(90),
                              child: CircleAvatar(
                                backgroundColor: AppColors.mainBlueColor,
                                radius: Dimensions.responsiveHeight(65),
                              ),
                            ),
                          ),
                          //Create Quiz Title
                          Padding(
                            padding: EdgeInsets.only(
                              top: Dimensions.statusBarHeight +
                                  Dimensions.height10,
                              left: Dimensions.width30,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    text: "Quiz",
                                    style: TextStyle(
                                      color: AppColors.logoBlueColor,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "app",
                                        style: TextStyle(
                                          color: AppColors.logoBluishWhiteColor,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const BigText(
                                      text: "Register New Account",
                                      textColor: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(height: Dimensions.height15),
                                    Row(
                                      children: [
                                        const CustomText(
                                          text: "Already have an account?",
                                          textColor: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            Get.offNamed(
                                                RouteHelper.getSignInPage());
                                          },
                                          child: const CustomText(
                                            text: "Sign In",
                                            textColor: AppColors.logoBlueColor,
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //Form Box
            ],
          ),
        ),
      ),
    );
  }
}
