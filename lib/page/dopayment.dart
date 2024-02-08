import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodgarden/page/generate_qr_code.dart';
import 'package:foodgarden/page/qr_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:foodgarden/model/saletransferModel.dart';
import 'package:foodgarden/source/source.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../app_config/common/app_strings.dart';
import '../app_config/common/widget/app_snackbar.dart';
import '../model/checkbalanceModel.dart';
import 'package:convert/src/hex.dart';

class DoPayment extends StatefulWidget {
  const DoPayment({super.key});

  @override
  State<DoPayment> createState() => _DoPaymentState();
}

class _DoPaymentState extends State<DoPayment> {
  var formatter = NumberFormat('#,###,000');
  late NfcManager _nfcManager;
  bool _isNfcSupportedDevice = false;
  bool _isLoading = false;
  final MethodChannel _platform = const MethodChannel('app_settings');
  bool _isPlateFormException = false;
  MifareClassic? _mifareClassic;
  final List<int> _blockIndex = List<int>.empty(growable: true);
  final List<int> _sectorIndex = List<int>.empty(growable: true);
  final List<Uint8List> _data = List<Uint8List>.empty(growable: true);
  final List<int> _defaultKey = [0xff, 0xff, 0xff, 0xff, 0xff, 0xff];
  final List<int> _defaultKeyA = [0x12, 0x34, 0x56, 0xAB, 0xCD, 0x12];
  int result = 0;
  String btn_1 = '';
  String btn_2 = '';
  String btn_3 = '';
  String btn_4 = '';
  String btn_5 = '';
  String btn_6 = '';
  String btn_7 = '';
  String btn_8 = '';
  String btn_9 = '';
  var print_count = 1;
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  @override
  void initState() {
    // popupCard();
    _nfcManager = NfcManager.instance;
    if (Platform.isAndroid) {
      _getNFCSupport();
    } else if (Platform.isIOS) {
      _isNfcSupportedDevice = true;
    }
    // TODO: implement initState
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

    loadQuickButton();
  }

  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  void _getNFCSupport() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      _isNfcSupportedDevice =
          await _platform.invokeMethod('isNFCSupportedDevice');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on PlatformException catch (e) {
      AppSnackBar(AppStrings.failedToGetDeviceIsNFCSupportableOrNot);
      AppSnackBar(e.message ?? e.runtimeType.toString());
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPlateFormException = true;
        });
      }
    }
  }

  static Future getURL() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getString('url') != null) {
      return sharedPref.getString('url');
    }
    return UrlConstants.initURL;
  }

  Future<SaleTransferModel> SaleTransfer(
      {required String Passkey,
      required int userId,
      required int merchantId,
      required String transactionNo,
      required String cardRegId,
      required String transactionDate,
      required String cardNumber,
      required double beforeBalance,
      required double transactionAmount}) async {
    final url = await getURL();
    final response = await http.post(Uri.parse('$url/Sale/SaleTransfer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Passkey": Passkey,
          "userId": userId,
          "merchantId": merchantId,
          "transactionNo": transactionNo,
          "cardRegId": cardRegId,
          "transactionDate": transactionDate,
          "cardNumber": cardNumber,
          "beforeBalance": beforeBalance,
          "transactionAmount": transactionAmount
        }));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final res = SaleTransferModel.fromJson(jsonDecode(response.body));

      if (res == null) {
        Fluttertoast.showToast(
          msg: "ບໍ່ສຳເລັດ",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          fontSize: 20.0,
        );
      }
      if (res.resultCode != "OK" && res.resultCode != "005") {
        print("responseSaleTransfer -> ${response.body}");
        Fluttertoast.showToast(
          msg: "${res.resultMessage}",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          fontSize: 20.0,
        );
      }
      if (res.resultCode == "OK" || res.resultCode == "005") {
        print("responseSaleTransfer -> ${response.body}");

        var c = print_count;
        
        do {
          await printSlip(
              lcompanyName,
              lmerchantId,
              CARDNO,
              res.billNo.toString(),
              tranAmt,
              endBal,
              DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now()).toString(),
              lfooter,
              merchantCopy: c < print_count);
          c--;
        } while (c > 0);
      }
      return res;
    } else {
      // print(response.statusCode);
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void dispose() {
    _nfcManager.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ບັນທຶກການຂາຍ'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : _isNfcSupportedDevice
              ? _nfcSupportedDeviceView()
              : _nfcSupportedDeviceErrorView(),
      // floatingActionButton: Container(
      //   height: 80.0,
      //   width: 80.0,
      //   child: FloatingActionButton(
      //     onPressed: () {

      //     },
      //     tooltip: 'Generate QR Code',
      //     child: const Icon(
      //       Icons.qr_code_scanner_rounded,
      //       size: 60,
      //       color: Colors.green,
      //     ),
      //   ),
      // )
    ); // This trailing comma makes auto-formatting nicer for build methods.);
  }

  Widget _nfcSupportedDeviceView() {
    return FutureBuilder<bool>(
      future: _nfcManager.isAvailable(),
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          return _nfcDisableFromPhoneView();
        } else {
          return mainDisplay();
        }
      },
    );
  }

  Widget _nfcDisableFromPhoneView() {
    return Padding(
      padding: const EdgeInsets.all(55),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Alert"),
          const SizedBox(height: 15),
          const Text(
            AppStrings.nFCIsDisableOnYourPhonePleaseEnableNFCFromSettings,
            textAlign: TextAlign.justify,
          ),
          Visibility(
            visible: Platform.isAndroid,
            child: TextButton(
              onPressed: () async {
                await _platform.invokeMethod('nfc');
                setState(() {});
              },
              child: const Text(AppStrings.pressToEnableNFC),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nfcSupportedDeviceErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Alert"),
          const SizedBox(height: 15),
          Text(
            _isPlateFormException
                ? AppStrings.failedToGetDeviceIsNFCSupportableOrNot
                : AppStrings.deviceIsNotNFCSupportable,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Column mainDisplay() {
    print("Main");
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildButtonCal(result, 1),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: buildButton(
                  int.parse(btn_1), 1, Color.fromARGB(255, 218, 216, 216)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: buildButton(
                  int.parse(btn_2), 1, Color.fromARGB(255, 218, 216, 216)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: buildButton(
                  int.parse(btn_3), 1, Color.fromARGB(255, 218, 216, 216)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: buildButton(
                  int.parse(btn_4), 1, Color.fromARGB(255, 218, 216, 216)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: buildButton(
                  int.parse(btn_5), 1, Color.fromARGB(255, 218, 216, 216)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: buildButton(
                  int.parse(btn_6), 1, Color.fromARGB(255, 218, 216, 216)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: buildButton(
                  int.parse(btn_7), 1, Color.fromARGB(255, 218, 216, 216)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: buildButton(
                  int.parse(btn_8), 1, Color.fromARGB(255, 218, 216, 216)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: buildButton(
                  int.parse(btn_9), 1, Color.fromARGB(255, 218, 216, 216)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
              child: buildButtonDel("ລຶບ", 1, Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
              child: buildButtonPay(
                  "ຈ່າຍເງິນ", 1, Color.fromARGB(255, 56, 148, 219)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: buildButtonPayByQr(
                  "ສ້າງ QR", 1, Color.fromARGB(255, 53, 211, 114)),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildButton(int val, double buttonHeight, Color buttonColor) {
    return Container(
      width: MediaQuery.of(context).size.width * .30,
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
          onPressed: () {
            btnclicked(val);
            print(val);
          },
          child: Text(
            "${formatter.format(val)}",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          )),
    );
  }

  void btnclicked(int btnText) {
    setState(() {
      result = result + btnText;
    });
  }

  void btnDel(int btnText) {
    setState(() {
      result = 0;
    });
  }

  Widget buildButtonDel(String text, double buttonHeight, Color buttonColor) {
    return Container(
      width: MediaQuery.of(context).size.width * .45,
      height: MediaQuery.of(context).size.height * 0.2 * buttonHeight,
      color: buttonColor,
      child: TextButton(
          onPressed: () {
            btnDel(0);
          },
          child: Text(
            text,
            style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          )),
    );
  }

  Widget buildButtonPay(String text, double buttonHeight, Color buttonColor) {
    return Container(
      width: MediaQuery.of(context).size.width * .47,
      height: MediaQuery.of(context).size.height * 0.2 * buttonHeight,
      color: buttonColor,
      child: TextButton(
          onPressed: () async {
            result == 0
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.warning,
                              size: 120,
                              color: Colors.yellow,
                            ),
                            Text(
                              "ກະລຸນາ ປ້ອນຈຳນວນເງິນ",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildPopupDialog(context);
                    },
                  );
            _tagRead();
            // await buildTagCard(context);
          },
          child: Text(
            text,
            style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          )),
    );
  }

  Widget buildButtonPayByQr(
      String text, double buttonHeight, Color buttonColor) {
    return Container(
      width: MediaQuery.of(context).size.width * .94,
      height: MediaQuery.of(context).size.height * 0.15 * buttonHeight,
      color: buttonColor,
      child: TextButton(
          onPressed: () async {
            // result == 0
            //     ? showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //             content: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: const <Widget>[
            //                 Icon(
            //                   Icons.warning,
            //                   size: 120,
            //                   color: Colors.yellow,
            //                 ),
            //                 Text(
            //                   "ກະລຸນາ ປ້ອນຈຳນວນເງິນ",
            //                   style: TextStyle(
            //                       fontSize: 24,
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.black38),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       )
                // :
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return QRImage(lshopCode, result);
                      }),
                    ),
                  );
          },
          child: Text(
            text,
            style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          )),
    );
  }

  Widget buildButtonCal(int val, double buttonHeight) {
    return Container(
      width: MediaQuery.of(context).size.width * .75,
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      // color: Colors.brown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {},
              child: result == 0
                  ? Text(
                      "$val",
                      style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 235, 133, 9)),
                    )
                  : Text(
                      "${formatter.format(val)}",
                      style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 235, 133, 9)),
                    )),
        ],
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Icon(
            Icons.credit_card,
            size: 120,
            color: Colors.red,
          ),
          Text(
            "ກະລຸນາ ແປະບັດ",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
          ),
        ],
      ),
    );
  }

  String UID = "";
  String CARDREG = "";
  String CARDNO = "";
  void _tagRead() async {
    try {
      _nfcManager.startSession(
        onDiscovered: (NfcTag tag) async {
          if (tag.data.containsKey("mifareclassic") &&
              (tag.data['mifareclassic']['size'] == 1024)) {
            await checkBalance(context, tag);
          } else {
            AppSnackBar(AppStrings.tagIsNotMifareClassic1K);
            setState(() {});
          }
          _nfcManager.stopSession();
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> checkBalance(BuildContext context, NfcTag tag) async {
    bool isConnectionLost = false;

    try {
      _mifareClassic = MifareClassic.from(tag);
      if (_mifareClassic?.size == 1024) {
        _blockIndex.clear();
        _sectorIndex.clear();
        _data.clear();
        final id = _mifareClassic!.identifier;
        UID = hex.encode(id).toUpperCase();
        print("UID:------------------------------- $UID");
        if (_mifareClassic != null) {
          for (int sectorIndex = 4; sectorIndex < 6; sectorIndex++) {
            bool isAuthenticateA =
                await _mifareClassic!.authenticateSectorWithKeyA(
              sectorIndex: sectorIndex,
              key: Uint8List.fromList(
                _defaultKeyA,
              ),
            );
            print("sectorIndex: $sectorIndex");
            print(isAuthenticateA);
            if (isAuthenticateA) {
              // print(hex.encode(_defaultKeyA).toUpperCase());

              Uint8List data = Uint8List.fromList([]);
              for (int blockIndex = sectorIndex * 4;
                  blockIndex < (sectorIndex * 4) + 4;
                  blockIndex++) {
                data = await _mifareClassic!.readBlock(blockIndex: blockIndex);
                _data.add(data);
                _blockIndex.add(blockIndex);

                if (blockIndex == 17) {
                  CARDREG =
                      hex.encode(data).toUpperCase().toString().substring(16);
                  print(
                      "---------------------------------------blockIndex: $blockIndex");
                  print(
                      "-----------------------------------------CARDREG -> $CARDREG");
                }

                if (blockIndex == 22) {
                  CARDNO = hex.encode(data).replaceAll(RegExp(r'^0+(?=.)'), '');
                  print(
                      "---------------------------------------blockIndex: $blockIndex");
                  print(
                      "-----------------------------------------CARDNO -> $CARDNO");
                }
              }
            }
            _sectorIndex.add(sectorIndex);
          }
        }
      } else {
        AppSnackBar(AppStrings.tagIsNotMifareClassic1K);
        setState(() {});
      }
    } catch (e) {
      AppSnackBar(AppStrings.nFCConnectionLost);
      print(e);
      setState(() {
        isConnectionLost = true;
      });
    } finally {
      if (!isConnectionLost) {
        // AppSnackBar(AppStrings.dataReadSuccessfully);

        doPayment();
      }
    }
  }

  late String tranAmt;
  late String endBal;
  var bill;
  late String billRef;

  void doPayment() async {
    await CheckBalanceModel.fetchCheckBalance(
        Passkey: lotp, userId: lUserId.toString(), cardUId: UID);
    var transactionNoFormat = DateFormat('yyMMddHHmmss');
    var transactionNo = transactionNoFormat.format(DateTime.now());
    print(transactionNo);
    var transactionDateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    var transactionDate = transactionDateFormat.format(DateTime.now());
    var f = NumberFormat("#.###");
    tranAmt = f.format(result);
    var endBa = LcardTotalBalance - result;
    endBal = f.format(endBa);
    print(endBal);
 
    var b = DateFormat('yyMMdd');
    bill = b.format(DateTime.now());
    var billcount = 1.toString();
    billRef = "$bill${lmerchantId.padLeft(4, '0')}${billcount.padLeft(4, '0')}";
    print(transactionDate);

    print(
        "otp: $lotp , userId: $lUserId , merchantId: $lmerchantId , transactionNo: $transactionNo");
    print(
        "cardRegId: $CARDREG , transactionDate: $transactionDate , cardNumber: $CARDNO , beforeBalance: $LcardTotalBalance , transactionAmount : ${result.toDouble()}");

    if (endBal == "0") {
      Fluttertoast.showToast(
        msg: "ເງິນໃນບັດຍັງເຫຼືອ 0 ກີບ ກະລຸນາເກັບບັດໄວ້ນໍາຮ້ານຄ້າ !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        fontSize: 20.0,
      );
    }

    if (result.toDouble() > LcardTotalBalance) {
      Fluttertoast.showToast(
        msg: "ຍອດເງິນບໍ່ພຽງພໍ",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        fontSize: 20.0,
      );
    } else {
      SaleTransfer(
          Passkey: lotp,
          userId: lUserId!,
          merchantId: int.parse(lmerchantId),
          transactionNo: transactionNo,
          cardRegId: CARDREG,
          transactionDate: transactionDate,
          cardNumber: CARDNO,
          beforeBalance: LcardTotalBalance,
          transactionAmount: result.toDouble());
    }

////////////////////////////////////////////
    Navigator.pop(context);
    setState(() {
      result = 0;
    });
  }

  Future<void> printSlip(
      String companyName,
      String merchantId,
      String cardNo,
      String refNo,
      String tranAmt,
      String endBal,
      String billDate,
      String footer,
      {bool merchantCopy = false}) async {
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
    if (merchantCopy) {
      await SunmiPrinter.printText(
        "--MERCHANT_COPY--",
        style: SunmiStyle(
            align: SunmiPrintAlign.CENTER,
            bold: true,
            fontSize: SunmiFontSize.MD),
      );
    }
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
      "ເລກບິນ/REF NO $refNo",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    await SunmiPrinter.printText(
      "ຈຳນວນຂາຍ/SALE AMOUNT $tranAmt",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    await SunmiPrinter.printText(
      "ຍອດເງິນຍັງເຫຼືອ/BALANCE $endBal",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    await SunmiPrinter.printText(
      "ວັນທີຂາຍ/DATE $billDate",
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

    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.exitTransactionPrint(true);
  }

   loadQuickButton() async {
    var pref = await SharedPreferences.getInstance();

    setState(() {
      btn_1 = pref.getString("num_1") ?? "1000";
      btn_2 = pref.getString("num_2") ?? "5000";
      btn_3 = pref.getString("num_3") ?? "10000";
      btn_4 = pref.getString("num_4") ?? "15000";
      btn_5 = pref.getString("num_5") ?? "20000";
      btn_6 = pref.getString("num_6") ?? "30000";
      btn_7 = pref.getString("num_7") ?? "50000";
      btn_8 = pref.getString("num_8") ?? "70000";
      btn_9 = pref.getString("num_9") ?? "100000";
    print_count = pref.getInt("print_count") ?? 1;
    });

    print("loadQuickButton ===> button3: $btn_3 , button1: $btn_1");
  }
}
