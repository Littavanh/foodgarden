import 'dart:async';

import 'package:foodgarden/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../storage/storage.dart';

import 'login_page.dart';

class SlapScreen extends StatefulWidget {
  const SlapScreen({Key? key}) : super(key: key);

  @override
  State<SlapScreen> createState() => _SlapScreenState();
}

class _SlapScreenState extends State<SlapScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Timer(
            Duration(seconds: 1),
                () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginPage())));
    return Container(
      color: Colors.white,
      child: const Center(
        child: Image(image: AssetImage('assets/images/foodgarden v2.png'))
      ),
    );
  }
}
