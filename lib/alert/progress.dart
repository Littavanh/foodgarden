

import 'package:foodgarden/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../style/color.dart';

Future myProgress(BuildContext context, Color? backgColor) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
            onWillPop: null,
            child: AlertDialog(
                backgroundColor: backgColor ?? Colors.white,
                elevation: 0,
                content: SizedBox(
                  height: 160,
                  width: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 8),
                      Text('ກະລຸນາລໍຖ້າ...',
                          style: TextStyle(
                              color: backgColor == null
                                  ? primaryColor
                                  : Colors.white)),
                    ],
                  ),
                )),
          ));
}

Future myProgressWaitPrint(BuildContext context, Color? backgColor) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
            onWillPop: null,
            child: AlertDialog(
                backgroundColor: backgColor ?? Colors.white,
                elevation: 0,
                content: SizedBox(
                  height: 160,
                  width: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 8),
                      Text('ກຳລັງໂຫຼດຂໍ້ມູນ...',
                          style: TextStyle(
                              color: backgColor == null
                                  ? textColor
                                  : Colors.white)),
                    ],
                  ),
                )),
          ));
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar(
    BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 6,
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(90, 0, 0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Text(message),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'OK',
        onPressed: () {},
      )));
}

Future<bool?> showCompletedDialog(
    {required BuildContext context,
    required String title,
    required String content}) {
  return showDialog<bool>(
      context: context,
      builder: (_) => WillPopScope(
            onWillPop: null,
            child: AlertDialog(
              title: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: bodyText2Bold),
                  ],
                ),
              ),
              content: SizedBox(
                width: double.minPositive,
                height: 120,
                child: Column(
                  children: [
                    const FaIcon(FontAwesomeIcons.circleCheck,
                        size: 60, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(content, textAlign: TextAlign.center)
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('ຕົກລົງ'))
              ],
            ),
          ));
}

Future<bool?> showFailDialog(
    {required BuildContext context,
    required String title,
    required String content}) {
  return showDialog<bool>(
      context: context,
      builder: (_) => WillPopScope(
            onWillPop: null,
            child: AlertDialog(
              title: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: bodyText2Bold),
                    // const Divider(color: primaryColor, height: 1),
                  ],
                ),
              ),
              content: SizedBox(
                width: double.minPositive,
                height: 170,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          size: 60, color: Colors.red),
                      const SizedBox(width: 6),
                      Text(content, textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              actions: [
                OutlinedButton(
                    onPressed: () => {Navigator.pop(context, true)},
                    child: const Text('ຕົກລົງ'))
              ],
            ),
          ));
}

Future<bool?> showQuestionDialog(
    {required BuildContext context,
    required String title,
    required String content}) {
  return showDialog<bool>(
      context: context,
      builder: (_) => WillPopScope(
            onWillPop: null,
            child: AlertDialog(
              title: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: bodyText2Bold),
                  ],
                ),
              ),
              content: SizedBox(
                width: double.minPositive,
                height: 120,
                child: Column(
                  children: [
                    const Icon(Icons.help_outline_rounded,
                        size: 60, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(content, textAlign: TextAlign.center)
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                    onPressed: () => {Navigator.pop(context, false)},
                    child: const Text('ບໍ່ແມ່ນ')),
                OutlinedButton(
                    onPressed: () => {Navigator.pop(context, true)},
                    child: const Text('ແມ່ນ'))
              ],
            ),
          ));
}
