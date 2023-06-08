import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp/utilities/dimensions.dart';
import 'package:quizapp/widgets/custom_text.dart';

import '../utilities/app_colors.dart';

class AppTextField extends StatefulWidget {
  String? hintText;
  IconData? prefixIcon;
  String? errorText;
  final bool hasHideButton;
  TextInputType? keyboardType;
  final TextEditingController textEditingController;
  final List<TextInputFormatter> inputFormatters;
  AppTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.errorText,
    required this.textEditingController,
    this.hasHideButton = false,
    this.keyboardType,
    this.inputFormatters = const [],
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool hasFocus = false;
  bool obscureText = false;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      setState(() {
        hasFocus = _focus.hasFocus;
      });
    });
    if (widget.hasHideButton) obscureText = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hasFocus
                  ? AppColors.mainBlueColor
                  : widget.errorText == null
                      ? AppColors.textColor
                      : Colors.red,
              width: hasFocus
                  ? 1.5
                  : widget.errorText == null
                      ? 0.2
                      : 1.5,
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowBlackColor,
                offset: Offset(1, 2),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextField(
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            obscureText: obscureText,
            focusNode: _focus,
            controller: widget.textEditingController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius:
                    BorderRadius.circular(Dimensions.responsiveHeight(13)),
              ),
              hintStyle: TextStyle(
                color: AppColors.textColor,
                fontSize: Dimensions.height15,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      size: Dimensions.height20 + Dimensions.height5,
                      color: (widget.errorText == null || hasFocus)
                          ? AppColors.mainBlueColor
                          : Colors.red,
                    )
                  : null,
              suffixIcon: widget.hasHideButton
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      child: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        size: Dimensions.height20 + Dimensions.height5,
                        color: (widget.errorText == null || hasFocus)
                            ? AppColors.mainBlueColor
                            : Colors.red,
                      ),
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.responsiveHeight(17)),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.2,
                  style: BorderStyle.solid,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(13),
                ),
              ),
              hintText: widget.hintText,
            ),
            onChanged: (value) {
              if (value == "") {
                // setState(() {
                //   widget.errorText = "This field is required";
                // });
              } else {
                setState(() {
                  widget.errorText = null;
                });
              }
            },
          ),
        ),
        widget.errorText == null
            ? const SizedBox(
                height: 0,
              )
            : Column(
                children: [
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomText(
                        text: widget.errorText!,
                        textColor: Colors.red,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              )
      ],
    );
  }
}
