import 'package:flutter/material.dart';
import 'package:foodgarden/app_config/common/app_color.dart';
import 'package:foodgarden/app_config/common/app_strings.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {Key? key,
      required this.size,
      this.isVisibleBackButton = false,
      this.titleText = AppStrings.mifareClassicTool})
      : super(key: key);
  final String titleText;
  final Size size;
  final bool isVisibleBackButton;

  @override
  Widget build(BuildContext context) {
    TextTheme themeData = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: AppColor.primarySwatch,
      elevation: 0,
      centerTitle: true,
      leading: isVisibleBackButton
          ? Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      )
          : const SizedBox.shrink(),
      title: Text(
        titleText,
        style: themeData.titleMedium,
      ),
    );
  }

  @override
  Size get preferredSize => size * 0.1;
}
