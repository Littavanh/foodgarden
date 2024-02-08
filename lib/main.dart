// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'package:foodgarden/page/login_page.dart';



import 'package:foodgarden/source/source.dart';
import 'package:foodgarden/style/color.dart';
import 'package:foodgarden/style/size.dart';
import 'package:foodgarden/style/textstyle.dart';

import 'package:google_fonts/google_fonts.dart';


late GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  setSettingButton();
 
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Garden',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        primarySwatch: themeColor,
        fontFamily: 'NotoSansLao',
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: themeColor,
          titleTextStyle: GoogleFonts.notoSansLao(textStyle: appBarText),
        ),
        primaryIconTheme:
            const IconThemeData(color: primaryColor, size: iconSize),
        iconTheme: const IconThemeData(color: primaryColor, size: iconSize),
        textTheme: TextTheme(
            bodyLarge: GoogleFonts.notoSansLao(textStyle: bodyText1),
            bodyMedium: GoogleFonts.notoSansLao(textStyle: bodyText2),
            displayLarge: GoogleFonts.notoSansLao(textStyle: header1Text),
            titleMedium: GoogleFonts.notoSansLao(textStyle: subTitle1)),
        primaryTextTheme: TextTheme(
            bodyLarge: GoogleFonts.notoSansLao(textStyle: bodyText1),
            bodyMedium: GoogleFonts.notoSansLao(textStyle: bodyText2),
            displayLarge: GoogleFonts.notoSansLao(textStyle: header1Text),
            titleMedium: GoogleFonts.notoSansLao(textStyle: subTitle1)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            textStyle: loginText,
            fixedSize: const Size(double.maxFinite, 48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
      home: const LoginPage(),
      //  home: const  SP(),
    );
  }
}
