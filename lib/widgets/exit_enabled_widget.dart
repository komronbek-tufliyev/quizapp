import 'package:flutter/material.dart';

import '../utilities/app_colors.dart';
import 'big_text.dart';
import 'custom_dialog.dart';

class ExitEnabledWidget extends StatefulWidget {
  final Widget child;
  const ExitEnabledWidget({
    super.key,
    required this.child,
  });

  @override
  State<ExitEnabledWidget> createState() => _ExitEnabledWidgetState();
}

class _ExitEnabledWidgetState extends State<ExitEnabledWidget> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool value = await showDialog(
            barrierColor: Colors.black12,
            context: context,
            builder: (context) {
              return CustomDialog(
                iconData: Icons.exit_to_app,
                title: "Quit",
                descriptionText: "Are you sure to quit?",
                actionWidgets: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const BigText(
                      text: "No",
                      textColor: AppColors.mainBlueColor,
                      size: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const BigText(
                      text: "Yes",
                      textColor: Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              );
            });
        return value;
      },
      child: widget.child,
    );
  }
}
