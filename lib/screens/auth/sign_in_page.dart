import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/auth_controller.dart';
import 'package:quizapp/routes/route_helper.dart';
import 'package:quizapp/widgets/effects/button_press_effect_container.dart';
import 'package:quizapp/widgets/exit_enabled_widget.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/app_constants.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/sign_in_options_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late AuthController _authController;
  String? emailErrorText, passwordErrorText;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  bool isFormValid() {
    bool isEmailValid = false;
    bool isPasswordValid = false;

    if (emailController.text.contains("@") &&
        emailController.text.contains(".")) {
      setState(() {
        emailErrorText = null;
      });
      isEmailValid = true;
    } else {
      setState(() {
        emailErrorText = "Invalid Email Format";
      });
    }

    if (passwordController.text.length < AppConstants.minimumPasswordLength) {
      setState(() {
        passwordErrorText =
            "Password must be at least ${AppConstants.minimumPasswordLength} characters";
      });
    } else {
      setState(() {
        passwordErrorText = null;
      });
      isPasswordValid = true;
    }

    if (isEmailValid && isPasswordValid) {
      return true;
    } else {
      return false;
    }
  }

  //dispose all controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                  top: Dimensions.height120 * 2.5,
                ),
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.responsiveWidth(20),
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        fontWeight: FontWeight.w500,
                        text: "Email",
                        textColor: Colors.black,
                        size: 16,
                      ),
                      SizedBox(height: Dimensions.height10),
                      AppTextField(
                        errorText: emailErrorText,
                        textEditingController: emailController,
                        prefixIcon: Icons.email_outlined,
                        hintText: "ABCXYZ@gmail.com",
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
                        hasHideButton: true,
                        errorText: passwordErrorText,
                        textEditingController: passwordController,
                        prefixIcon: Icons.lock_outline,
                        hintText: "Password",
                      ),
                      SizedBox(height: Dimensions.height10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.offNamed(RouteHelper.getForgotPasswordPage());
                            },
                            child: const CustomText(
                              text: "Forgot Password?",
                              textColor: AppColors.logoBlueColor,
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height30),
                      ButtonPressEffectContainer(
                        onTapFunction: () async {
                          if (isFormValid()) {
                            await _authController.signIn(
                                emailController.text.trim(),
                                passwordController.text.trim());
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
                            text: "Sign In",
                          ),
                        ),
                      ),
                      //forgot password

                      SizedBox(height: Dimensions.height20),
                      const Center(
                        child: CustomText(
                          text: "Sign In With",
                          textColor: AppColors.mainBlueColor,
                          size: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      SignInOptionsWidget(),
                    ],
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
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Dimensions.height20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const BigText(
                                        text: "Sign In",
                                        textColor: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(height: Dimensions.height15),
                                      Row(
                                        children: [
                                          const CustomText(
                                            text: "Don't have an account?",
                                            textColor: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () {
                                              Get.offNamed(
                                                  RouteHelper.getSignUpPage());
                                            },
                                            child: const CustomText(
                                              text: "Sign Up",
                                              textColor:
                                                  AppColors.logoBlueColor,
                                              size: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
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
