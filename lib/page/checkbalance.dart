import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:foodgarden/model/checkbalanceModel.dart';

import 'package:foodgarden/source/source.dart';

import 'package:http/http.dart' as http;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import '../alert/progress.dart';

import '../app_config/common/app_strings.dart';
import '../app_config/common/widget/app_snackbar.dart';
import '../source/source.dart';
import 'package:convert/src/hex.dart';

class CheckBalance extends StatefulWidget {
  const CheckBalance({super.key});

  @override
  State<CheckBalance> createState() => _CheckBalanceState();
}

// MifareClassic mMifareClassic = MifareClassic.get(tag);
// byte[] uid = mMifareClassic.getID();
class _CheckBalanceState extends State<CheckBalance> {
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


  // late final Future<CheckBalanceModel> myFuture = CheckBalanceModel.fetchCheckBalance(
  //                             cardUId: UID);
  @override
  void initState() {
    popupCard();
    _nfcManager = NfcManager.instance;
    if (Platform.isAndroid) {
      _getNFCSupport();
    } else if (Platform.isIOS) {
      _isNfcSupportedDevice = true;
    }
    // TODO: implement initState
    super.initState();
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

  @override
  void dispose() {
    _nfcManager.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
      
        title: const Text('ກວດຍອດເງິນ'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : _isNfcSupportedDevice
              ? _nfcSupportedDeviceView()
              : _nfcSupportedDeviceErrorView(),
    );
  }

  Widget _nfcSupportedDeviceView() {
    return FutureBuilder<bool>(
      future: _nfcManager.isAvailable(),
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          return _nfcDisableFromPhoneView();
        } else {
          return mainDisplay(context);
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

  Column mainDisplay(BuildContext context) {
    print("Main");
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_constructors
              children: <Widget>[
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'ຍອດເງິນຂອງທ່ານມີ',
                      style: TextStyle(fontSize: 18),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: UID != ""
                      ? FutureBuilder<CheckBalanceModel>(
                          future: CheckBalanceModel.fetchCheckBalance(Passkey: lotp,userId: lUserId.toString(),
                              cardUId: UID),
                          builder: ((context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Text(
                                snapshot.data!.cardTotalBalance!.toString(),
                                style: const TextStyle(fontSize: 36),
                              );
                            }
                          }))
                      : const Text("..."),
                ),
              ]),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildPopupDialog(context);
                        },
                      );

                      _tagRead();
                    },
                    child: const Text(
                      "ກວດຍອດເງິນ",
                      style: TextStyle(fontSize: 24),
                    )),
                // Divider(),
                // ElevatedButton(
                //     onPressed: ()  async{
                 
                //     },
                //     child: const Text(
                //       "CardUID",
                //       style: TextStyle(fontSize: 24),
                //     )),
              ],
            ),
          ),
        ),
      ],
    );
  }
String UID = "";
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
                  String CARDREG =
                      hex.encode(data).toUpperCase().toString().substring(16);
                  print(
                      "---------------------------------------blockIndex: $blockIndex");
                  print(
                      "-----------------------------------------CARDREG -> $CARDREG");
                }

                if (blockIndex == 22) {
                  String CARDNO =
                      hex.encode(data).replaceAll(RegExp(r'^0+(?=.)'), '');
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
        setState(() {
          // CheckBalanceModel.fetchCheckBalance(cardUId: UID);

          Navigator.pop(context);
          
        });
      }
    }
  }

  Future<void> popupCard() async {
    Future.delayed(Duration.zero, () async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildPopupDialog(context);
        },
      );
       _tagRead();
    });
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
}
