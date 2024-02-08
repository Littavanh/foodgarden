import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:foodgarden/model/loginModel.dart';
import 'package:foodgarden/page/settings.dart';
import 'package:foodgarden/screen/home.dart';
import 'package:foodgarden/style/color.dart';

import '../alert/progress.dart';
import '../controller/customcontainer.dart';

import '../storage/storage.dart';

import '../style/size.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _serialNumber = "unknown";

  //
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  String emptyUsername = "";
  String emptyPassword = "";
  bool _showPassword = true;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    // await FlutterDeviceIdentifier.requestPermission();
    _serialNumber = await FlutterDeviceIdentifier.serialCode;
    print("serialNumber : $_serialNumber");

    _userController.text = _serialNumber;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    print("Login : ");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
            child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              // SizedBox(
              //   height: MediaQuery.of(context).size.height,
              //   child: Image.asset('assets/images/foodgarden v2.png'),
              // ),
              Center(
                  child: Column(
                children: [
                  // const SizedBox(height: 80),

                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      // height: size.height / 3,
                      child: Text(""),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(radius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: SizedBox(
                              width: size.width * .9,
                              child: Column(
                                children: [
                                  // const Icon(Icons.account_circle, size: 100),

                                  _buildForm()
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Form(
        child: Column(children: [
          Image.asset(
            'assets/images/foodgarden v2.png',
            width: 150,
            height: 150,
          ),
          SizedBox(
            height: 10,
          ),
          CustomContainer(
              title: const Text("ລະຫັດ"),
              borderRadius: BorderRadius.circular(radius),
              errorMsg: emptyUsername,
              child: TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                        color: primaryColor,
                        size: iconSize,
                      )),
                  onChanged: (text) => _userController.text.isNotEmpty
                      ? setState(() => emptyUsername = "")
                      : null)),
          CustomContainer(
              title: const Text("ລະຫັດລັບ"),
              borderRadius: BorderRadius.circular(radius),
              errorMsg: emptyPassword,
              child: TextFormField(
                  controller: _passwordController,
                  obscureText: _showPassword,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.security_rounded,
                        size: iconSize,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                          icon: _showPassword
                              ? const Icon(Icons.visibility_rounded,
                                  color: Colors.grey)
                              : const Icon(Icons.visibility_off_rounded,
                                  color: primaryColor),
                          onPressed: () {
                            setState(() => _showPassword = !_showPassword);
                          })),
                  onChanged: (text) => _passwordController.text.isNotEmpty
                      ? setState(() => emptyPassword = "")
                      : null)),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => _login(), child: const Text('ເຂົ້າສູ່ລະບົບ')),
          ),
          const SizedBox(height: 20),
          GestureDetector(
              onDoubleTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  ),
              child: IconButton(onPressed: () {}, icon: Icon(Icons.settings))),
        ]),
      ),
    );
  }

  void _login() async {
    myProgress(context, Colors.transparent);
    print(_userController.text);

    await LoginModel.login(
            passkey: "a486f489-76c0-4c49-8ff0-d0fdec0a162b",
            digitalSignature: "",
            userName: _userController.text,
            userPassword: "")
        .then((login) async {
      if (login.userId != null && login.merchantName != null) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        print("ບໍ່ສາມາດເຂົ້າສູ່ລະບົບ ${login.resultMessage}");
        Navigator.pop(context);
        mySnackBar(context, "ບໍ່ສາມາດເຂົ້າສູ່ລະບົບ ${login.resultMessage}");
      }
    }).catchError((onError) {
      Navigator.pop(context);
      mySnackBar(context, onError.toString());
    });
  }
}
