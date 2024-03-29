import 'dart:async';
import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodgarden/controller/customcontainer.dart';
import 'package:foodgarden/page/checkbalance.dart';
import 'package:foodgarden/page/dopayment.dart';
import 'package:foodgarden/page/history.dart';
import 'package:foodgarden/page/noti_auto_print.dart';
import 'package:foodgarden/page/printReciept.dart';
import 'package:foodgarden/page/result.dart';
import 'package:foodgarden/page/settings.dart';
import 'package:foodgarden/screen/read_data_screen.dart';
import 'package:foodgarden/style/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../component/component.dart';

import '../main.dart';
import '../source/source.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _serialNumber = "unknown";
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  //
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  void initState() {
    super.initState();
    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });

    initPlatformState();

    Timer.periodic(
      const Duration(seconds: 2),
      (timer) => getNotiAndAutoPrint(lotp),
    );
  }

  Future<void> initPlatformState() async {
    String serialNumber;

    try {
      serialNumber = await FlutterDeviceIdentifier.serialCode;
    } on PlatformException {
      serialNumber = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _serialNumber = serialNumber;
    });
  }

  Future getURL() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getString('url') != null) {
      return sharedPref.getString('url');
    }
    return UrlConstants.initURL;
  }

  Future<void> getNotiAndAutoPrint(String token) async {
    print('otp: $token');

    final url = await getURL();
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({"tokenKey": token});
    var dio = Dio();
    var response = await dio.request(
      '$url/payment/BillPrintingMerchant',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      if (response.data["resultCode"] == "200") {
        var notiText =
            'merchantId: ${lmerchantId}  CardNo: ${response.data["cardNo"]}  BillNo: ${response.data["billNo"]}  Amount: ${response.data["saleAmount"]} Date: ${response.data["saleDate"]}';
        print(notiText);
        var transactionId = response.data["transactionId"];
        print(json.encode(response.data));
        print("print Bill");

        // show notification
        FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
        var android = AndroidInitializationSettings('@mipmap/ic_launcher');
        // var iOS = IOSInitializationSettings();
        var initSetttings = InitializationSettings(android: android);
        flp.initialize(initSetttings);

        showNotification(notiText, flp);

        // ignore: use_build_context_synchronously
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) =>
        //NotiAutoPrint(transactionId: response.data["transactionId"],merchantId: lmerchantId,cardNo: response.data["cardNo"],
        //billNo: response.data["billNo"],saleAmount: response.data["saleAmount"],totalBalance: response.data["totalBalance"],
        //saleDate: response.data["saleDate"])),
        // );
        printSlip(
            token: token,
            dio: dio,
            url: url,
            companyName: lcompanyName,
            transactionId: transactionId,
            merchantId: lmerchantId,
            cardNo: response.data["cardNo"],
            billNo: response.data["billNo"],
            saleAmount: response.data["saleAmount"],
            totalBalance: response.data["totalBalance"],
            saleDate: response.data["saleDate"]);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ResultPage(saleAmount: response.data["saleAmount"])),
        );
      } else {
        print("no have bill to print");
      }
    } else {
      print(response.statusMessage);
    }
  }

  Future<void> printSlip(
      {required String token,
      required Dio dio,
      required String url,
      required String companyName,
      required String transactionId,
      required String merchantId,
      required String cardNo,
      required String billNo,
      required String saleAmount,
      required String totalBalance,
      required String saleDate}) async {
    print('printslip: $companyName,$transactionId,$merchantId');
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.printText(
      companyName,
      style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
          bold: true,
          fontSize: SunmiFontSize.MD),
    );

    await SunmiPrinter.printText(
      "****************************",
      style:
          SunmiStyle(align: SunmiPrintAlign.CENTER, fontSize: SunmiFontSize.SM),
    );

    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      "ລະຫັດຮ້ານຄ້າ/MERCHANT ID ${merchantId.padLeft(4, '0')}",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    await SunmiPrinter.printText(
      "ລະຫັດບັດ/CARD NO $cardNo",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    await SunmiPrinter.printText(
      "ເລກບິນ/REF NO $transactionId",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    await SunmiPrinter.printText(
      "ຈຳນວນຂາຍ/SALE AMOUNT $saleAmount",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    await SunmiPrinter.printText(
      "ຍອດເງິນຍັງເຫຼືອ/BALANCE $totalBalance",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    await SunmiPrinter.printText(
      "ວັນທີຂາຍ/DATE $saleDate",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    await SunmiPrinter.printText(
      "****************************",
      style:
          SunmiStyle(align: SunmiPrintAlign.CENTER, fontSize: SunmiFontSize.SM),
    );
    await SunmiPrinter.printText(
      lfooter,
      style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD,
          bold: true),
    );
    await billPrintSuccess(token, transactionId, dio, url);
    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.exitTransactionPrint(true);
  }

  Future<void> billPrintSuccess(
      String token, transactionId, Dio dio, url) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "publicKey": token,
      "userName": lmerchantName,
      "transactionId": transactionId,
      "merchantId": lmerchantId
    });

    var response1 = await dio.request(
      '$url/payment/BillPrintSuccessMerchant',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response1.statusCode == 200) {
      print(json.encode(response1.data));
      print("done...");
    } else {
      print(response1.statusMessage);
    }
  }

  void showNotification(v, flp) async {
    var android = const AndroidNotificationDetails('channel id', 'channel NAME',
        priority: Priority.high, importance: Importance.max);
    // var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android);
    await flp.show(0, 'ຊຳລະເງິນສຳເລັດ', '$v', platform, payload: 'VIS \n $v');
  }

  @override
  Widget build(BuildContext context) {
    print("Home");
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        drawer: Drawer(
          child: ListView(children: [
            DrawerHeader(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${lmerchantId.padLeft(4, '0')} $lmerchantName"),
                Text("ລະຫັດ: $_serialNumber"),
              ],
            )),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings),
                  Text("ການຕັ້ງຄ່າ"),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            )
          ]),
        ),
        appBar: AppBar(
          title: const Text("FoodCourt"),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DoPayment()),
                    );
                  },
                  child: Container(
                    height: 195.0,
                    color: Colors.green,
                    child: const Center(
                      child: Text(
                        'ບັນທຶກການຂາຍ',
                        style: TextStyle(fontSize: 36, color: textColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const History()),
                    );
                  },
                  child: Container(
                    height: 195.0,
                    color: Colors.cyan,
                    child: const Center(
                      child: Text(
                        'ປະຫວັດການຂາຍ',
                        style: TextStyle(fontSize: 36, color: textColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CheckBalance()),
                    );
                  },
                  child: Container(
                    height: 195.0,
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        'ກວດຍອດເງິນ',
                        style: TextStyle(fontSize: 36, color: textColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
