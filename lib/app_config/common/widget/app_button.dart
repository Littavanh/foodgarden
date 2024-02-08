import 'package:flutter/material.dart';
import 'package:foodgarden/app_config/common/app_color.dart';

class AppButton extends StatelessWidget {
  const AppButton({Key? key, required this.onTap, required this.buttonText})
      : super(key: key);
  final VoidCallback onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColor.blackColor,
        ),
        child: Text(buttonText, textAlign: TextAlign.center),
      ),
    );
  }
}
