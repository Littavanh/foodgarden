import 'package:flutter/material.dart';
import 'package:foodgarden/app_config/common/app_color.dart';
import 'package:foodgarden/main.dart';

class AppSnackBar {
  AppSnackBar(String msg) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: AppColor.whiteColor),
        ),
        backgroundColor: AppColor.blackColor,
        margin: EdgeInsets.only(
            bottom: scaffoldMessengerKey.currentContext != null
                ? MediaQuery.of(scaffoldMessengerKey.currentContext!)
                        .size
                        .height *
                    0.75
                : 520,
            left: 25,
            right: 25),
        shape: const StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
