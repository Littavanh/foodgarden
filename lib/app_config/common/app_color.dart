import 'package:flutter/material.dart';

class AppColor {
  static final Map<int, Color> _color = <int, Color>{
    50: const Color.fromRGBO(96, 96, 103, .1),
    100: const Color.fromRGBO(96, 96, 103, .2),
    200: const Color.fromRGBO(96, 96, 103, .3),
    300: const Color.fromRGBO(96, 96, 103, .4),
    400: const Color.fromRGBO(96, 96, 103, .5),
    500: const Color.fromRGBO(96, 96, 103, .6),
    600: const Color.fromRGBO(96, 96, 103, .7),
    700: const Color.fromRGBO(96, 96, 103, .8),
    800: const Color.fromRGBO(96, 96, 103, .9),
    900: const Color.fromRGBO(96, 96, 103, 1.0),
  };
  static MaterialColor primarySwatch = MaterialColor(0xff606067, _color);

  static Color blackColor = Colors.black;

  static Color whiteColor = Colors.white;
}
