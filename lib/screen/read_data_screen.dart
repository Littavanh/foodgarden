import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodgarden/app_config/common/app_color.dart';
import 'package:foodgarden/app_config/common/app_strings.dart';
import 'package:foodgarden/app_config/common/custom_scroll_behaviour.dart';
import 'package:foodgarden/app_config/common/widget/app_bar.dart';
import 'package:foodgarden/app_config/common/widget/app_button.dart';
import 'package:foodgarden/app_config/common/widget/app_snackbar.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class ReadDataScreen extends StatefulWidget {
  const ReadDataScreen({Key? key}) : super(key: key);

  @override
  State<ReadDataScreen> createState() => _ReadDataScreenState();
}

class _ReadDataScreenState extends State<ReadDataScreen> {
  Size _size = Size.zero;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _sheetController;
  bool _isVisibleWriteButtonView = false;
  bool _isVisibleBottomNavBar = false;
  bool _isVisibleBackButton = true;
  bool _isLoading = false;
  bool _isNfcSupportedDevice = false;
  bool _isPlateFormException = false;
  final MethodChannel _platform = const MethodChannel('app_settings');
  late NfcManager _nfcManager;
  int _selectedToggle = 0;
  final List<bool> _isSelectedToggleList = [true, false];
  int? _selectedSectorIndex;
  int? _selectedBlockIndex;
  MifareClassic? _mifareClassic;
  final List<int> _blockIndex = List<int>.empty(growable: true);
  final List<int> _sectorIndex = List<int>.empty(growable: true);
  final List<Uint8List> _data = List<Uint8List>.empty(growable: true);
  final List<int> _defaultKey = [0xff, 0xff, 0xff, 0xff, 0xff, 0xff];
  final List<int> _defaultKeyA = [0x12, 0x34, 0x56, 0xAB, 0xCD, 0x12];
  late TextTheme _textThemeData;

  @override
  void initState() {
    _nfcManager = NfcManager.instance;
    if (Platform.isAndroid) {
      _getNFCSupport();
    } else if (Platform.isIOS) {
      _isNfcSupportedDevice = true;
    }
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
    _size = MediaQuery.of(context).size;
    _textThemeData = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: _toggleButtonView(),
      appBar: MyAppBar(
        isVisibleBackButton: _isVisibleBackButton,
        size: _size,
        titleText: AppStrings.readData,
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

  Widget _nfcSupportedDeviceErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _alertTextView,
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

  Widget _nfcSupportedDeviceView() {
    return FutureBuilder<bool>(
      future: _nfcManager.isAvailable(),
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          return _nfcDisableFromPhoneView();
        } else {
          return _nfcEnableFromPhoneView();
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
          _alertTextView,
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

  Widget _nfcEnableFromPhoneView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [_readButtonView(), _writeButtonView(), _dataView()],
      ),
    );
  }

  Widget _toggleButtonView() {
    return Visibility(
      visible: _isVisibleBottomNavBar,
      child: ToggleButtons(
        selectedColor: AppColor.whiteColor,
        fillColor: AppColor.blackColor,
        tapTargetSize: MaterialTapTargetSize.padded,
        borderRadius: BorderRadius.circular(35),
        onPressed: (value) {
          setState(() {
            _selectedToggle = value;
            if (value == 1) {
              _isSelectedToggleList[0] = false;
              _isSelectedToggleList[1] = true;
            } else {
              _isSelectedToggleList[1] = false;
              _isSelectedToggleList[0] = true;
            }
          });
        },
        isSelected: _isSelectedToggleList,
        children: [
          Container(
            alignment: Alignment.center,
            width: _size.width * 0.5,
            child: const Text(AppStrings.hexadecimal),
          ),
          Container(
            alignment: Alignment.center,
            width: _size.width * 0.49,
            child: const Text(AppStrings.ascii),
          ),
        ],
      ),
    );
  }

  Widget get _alertTextView {
    return const Text(
      AppStrings.alert,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  Widget _readButtonView() {
    return AppButton(
      onTap: () {
        _showBottomSheet();
        setState(() {
          _isVisibleBackButton = false;
          _isVisibleBottomNavBar = false;
        });
        _tagRead();
      },
      buttonText: AppStrings.readData,
    );
  }

  Widget _writeButtonView() {
    return Visibility(
      visible: _isVisibleWriteButtonView,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: _size.width * 0.4,
              child: AppButton(
                onTap: () {
                  setState(() {
                    _isVisibleBackButton = false;
                    _isVisibleBottomNavBar = false;
                  });
                  _showBottomSheet();
                  _writeData("mifareclassic");
                },
                buttonText: AppStrings.writeDataMifareClassic,
              ),
            ),
            SizedBox(
              width: _size.width * 0.4,
              child: AppButton(
                onTap: () {
                  setState(() {
                    _isVisibleBackButton = false;
                    _isVisibleBottomNavBar = false;
                  });
                  _showDialog();
                },
                buttonText: AppStrings.writeDataMifareUltralight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    _sheetController = _scaffoldKey.currentState?.showBottomSheet(
      (context) {
        return Center(
          child: Icon(
            Icons.nfc,
            size: _size.height * 0.3,
          ),
        );
      },
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      backgroundColor: AppColor.blackColor,
      enableDrag: false,
      elevation: 0,
      constraints: BoxConstraints(
        minHeight: _size.height * 0.5,
        maxHeight: _size.height * 0.5,
        minWidth: _size.width,
      ),
    );
  }

  void _showDialog() async {
    List<int> blockIndexList = List<int>.empty(growable: true);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter alertBoxSetState) {
            return AlertDialog(
              title: _mifareUltralightSelectSectorView(
                blockIndexList,
                alertBoxSetState,
              ),
              content: SingleChildScrollView(
                child: Visibility(
                  visible: _selectedSectorIndex != null,
                  child: _mifareUltralightSelectBlockView(
                    blockIndexList,
                    alertBoxSetState,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _mifareUltralightSelectSectorView(
    List<int> blockIndexList,
    StateSetter alertBoxSetState,
  ) {
    List<int> sectorIndexList = List<int>.generate(16, (index) => index);
    return Wrap(
      children: [
        Text(AppStrings.selectSector, style: _textThemeData.bodyMedium),
        DropdownButtonFormField<int>(
          decoration: InputDecoration(
            hintText: AppStrings.selectSector,
            hintStyle: _textThemeData.bodyMedium,
          ),
          menuMaxHeight: 200,
          items: List<DropdownMenuItem<int>>.from(
            sectorIndexList.map(
              (value) => DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: _textThemeData.bodyMedium,
                ),
              ),
            ),
          ),
          onChanged: (int? value) {
            alertBoxSetState(() {
              _selectedSectorIndex = value;
            });

            if (_selectedSectorIndex != null) {
              for (int blockIndex = _selectedSectorIndex! * 4;
                  blockIndex < (_selectedSectorIndex! * 4) + 4;
                  blockIndex++) {
                blockIndexList.add(blockIndex);
              }
            }
          },
        ),
      ],
    );
  }

  Widget _mifareUltralightSelectBlockView(
      List<int> blockIndexList, StateSetter alertBoxSetState) {
    return Wrap(
      children: [
        Text(
          AppStrings.selectSector,
          style: _textThemeData.bodyMedium,
        ),
        DropdownButtonFormField<int>(
          decoration: InputDecoration(
            hintText: AppStrings.selectBlock,
            hintStyle: _textThemeData.bodyMedium,
          ),
          menuMaxHeight: 200,
          items: List<DropdownMenuItem<int>>.from(
            blockIndexList.map(
              (value) => DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: _textThemeData.bodyMedium,
                ),
              ),
            ),
          ),
          onChanged: (int? value) {
            _selectedBlockIndex = value;
            alertBoxSetState(() {});
          },
        ),
        Visibility(
          visible: _selectedBlockIndex != null,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: AppButton(
              onTap: () {
                Navigator.of(context).pop();
                _writeData("mifareultralight");
                _showBottomSheet();
              },
              buttonText: AppStrings.writeData,
            ),
          ),
        )
      ],
    );
  }

  Widget _dataView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 5),
        child: ScrollConfiguration(
          behavior:
              SpecifiableOverscrollColorScrollBehavior(AppColor.primarySwatch),
          child: Scrollbar(
            child: ListView.builder(
              itemCount: _sectorIndex.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (itemBuilder, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sector : ${_sectorIndex[index]}"),
                      const SizedBox(height: 10),
                      for (int blockIndex = index * 4;
                          blockIndex < (index * 4) + 4;
                          blockIndex++)
                        _listView(blockIndex)
                    ],
                  ),
                );
              },
              shrinkWrap: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _listView(int blockIndex) {
    List<String> hexStringList = List<String>.empty(growable: true);
    List<int> dataList = List<int>.empty(growable: true);
    if (_selectedToggle == 0) {
      for (var element in _data[blockIndex]) {
        hexStringList.add(element.toRadixString(16));
      }
    } else {
      for (var element in _data[blockIndex]) {
        if (element > 31 && element < 128) {
          dataList.add(element);
          dataList.add(32);
        } else {
          dataList.add(46);
          dataList.add(32);
        }
      }
    }
    // _data[blockIndex];
    String data = const AsciiDecoder(allowInvalid: true).convert(dataList);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: _selectedToggle == 0
          ? Text(
              "  Block : ${blockIndex.toString()} \n     ${hexStringList.join(" ").toUpperCase()}")
          : Text("  Block : ${blockIndex.toString()} \n     $data"),
    );
  }

  void _tagRead() async {
    try {
      _nfcManager.startSession(
        onDiscovered: (NfcTag tag) async {
          if (tag.data.containsKey("mifareclassic") &&
              (tag.data['mifareclassic']['size'] == 1024)) {
            await _handleReadTag(tag);
          } else {
            _sheetController?.close();
            AppSnackBar(AppStrings.tagIsNotMifareClassic1K);
            setState(() {
              _isVisibleBottomNavBar = false;
              _isVisibleWriteButtonView = false;
              _isVisibleBackButton = true;
            });
          }
          _nfcManager.stopSession();
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

 

  Future<void> _handleReadTag(NfcTag tag) async {
    bool isConnectionLost = false;
    try {
      _mifareClassic = MifareClassic.from(tag);
      if (_mifareClassic?.size == 1024) {
        _blockIndex.clear();
        _sectorIndex.clear();
        _data.clear();
        final UID = _mifareClassic!.identifier;
        print(
            "UID:------------------------------- ${hex.encode(UID).toUpperCase()}");
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
                  String CARDREG = hex.encode(data).toUpperCase().toString().substring(16);
                  print(
                      "---------------------------------------blockIndex: $blockIndex");
                  print(
                      "-----------------------------------------CARDREG -> $CARDREG");
                }
                
                if (blockIndex == 22) {
                  String CARDNO =hex.encode(data).replaceAll(RegExp(r'^0+(?=.)'), '');
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
        _sheetController?.close();
        AppSnackBar(AppStrings.tagIsNotMifareClassic1K);
        setState(() {
          _isVisibleBackButton = true;
          _isVisibleWriteButtonView = false;
          _isVisibleBottomNavBar = false;
        });
      }
    } catch (e) {
      _sheetController?.close();
      AppSnackBar(AppStrings.nFCConnectionLost);
      print(e);
      setState(() {
        isConnectionLost = true;
        _isVisibleBackButton = true;
        _isVisibleWriteButtonView = false;
        _isVisibleBottomNavBar = false;
      });
    } finally {
      if (!isConnectionLost) {
        _sheetController?.close();
        AppSnackBar(AppStrings.dataReadSuccessfully);
        setState(() {
          _isVisibleBackButton = true;
          _isVisibleWriteButtonView = true;
          _isVisibleBottomNavBar = true;
        });
      }
    }
  }

  void _writeData(String checkButtonTapped) {
    try {
      _nfcManager.startSession(onDiscovered: (NfcTag tag) async {
        if (checkButtonTapped.contains("mifareclassic") &&
            tag.data.containsKey("mifareclassic")) {
          await _handleWriteDataOnMifareClassic1K(tag);
        } else if (checkButtonTapped.contains("mifareultralight") &&
            tag.data.containsKey("mifareultralight")) {
          await _handleWriteDataOnMifareUltralight(tag);
        } else if ((checkButtonTapped.contains("mifareclassic") &&
                tag.data.containsKey("mifareultralight")) ||
            (checkButtonTapped.contains("mifareultralight") &&
                tag.data.containsKey("mifareclassic"))) {
          _sheetController?.close();
          AppSnackBar(AppStrings.tagMissMatchedErr);
          _isVisibleBottomNavBar = true;
          _isVisibleBackButton = true;
          setState(() {});
        } else {
          _sheetController?.close();
          AppSnackBar(AppStrings.tagIsNotMifareClassic1KOrMifareUltralight);
          _isVisibleBottomNavBar = true;
          _isVisibleBackButton = true;
          setState(() {});
        }
        _nfcManager.stopSession();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _handleWriteDataOnMifareClassic1K(NfcTag tag) async {
    bool isConnectionLost = false;
    if (tag.data['mifareclassic']['size'] == 1024) {
      try {
        _mifareClassic = MifareClassic.from(tag);
        if (_mifareClassic != null) {
          for (int sectorIndex = 0;
              sectorIndex < _mifareClassic!.sectorCount;
              sectorIndex++) {
            bool isAuthenticateB =
                await _mifareClassic!.authenticateSectorWithKeyB(
              sectorIndex: sectorIndex,
              key: Uint8List.fromList(
                _defaultKey,
              ),
            );
            if (isAuthenticateB) {
              for (int blockIndex = sectorIndex * 4;
                  blockIndex < (sectorIndex * 4) + 4;
                  blockIndex++) {
                if ((sectorIndex == 0 && blockIndex == 0) ||
                    (blockIndex == (sectorIndex * 4) + 3)) {
                } else {
                  _mifareClassic?.writeBlock(
                      blockIndex: blockIndex, data: _data[blockIndex]);
                }
              }
            }
          }
        }
      } catch (e) {
        _sheetController?.close();
        AppSnackBar(AppStrings.nFCConnectionLost);
        setState(() {
          isConnectionLost = true;
          _isVisibleBackButton = true;
          _isVisibleWriteButtonView = true;
          _isVisibleBottomNavBar = true;
        });
      } finally {
        if (!isConnectionLost) {
          _sheetController?.close();
          AppSnackBar(AppStrings.dataWriteSuccessfully);
          setState(() {
            _isVisibleBackButton = true;
            _isVisibleWriteButtonView = true;
            _isVisibleBottomNavBar = true;
          });
        }
      }
    } else {
      AppSnackBar(AppStrings.unableToWriteBecauseTagIsMifareClassic4k);
      _sheetController?.close();
      setState(() {
        _isVisibleBackButton = true;
        _isVisibleBottomNavBar = true;
        _isVisibleWriteButtonView = true;
      });
    }
  }

  Future<void> _handleWriteDataOnMifareUltralight(NfcTag tag) async {
    List<int> dataList = List<int>.empty(growable: true);
    int ndefMaxSize = 0;
    for (int i = 0; i < _data[_selectedBlockIndex!].length; i++) {
      if (_data[_selectedBlockIndex!][i] > 31 &&
          _data[_selectedBlockIndex!][i] < 128) {
        dataList.add(_data[_selectedBlockIndex!][i]);
      }
    }
    String writtenData =
        const AsciiDecoder(allowInvalid: true).convert(dataList);

    try {
      Ndef? ndef = Ndef.from(tag);
      if (ndef != null) {
        ndefMaxSize = ndef.maxSize;
        bool isEmpty = writtenData == "";
        setState(() {});
        if (isEmpty) {
          AppSnackBar(AppStrings.dataIsEmpty);
        } else {
          if (ndefMaxSize >= writtenData.length) {
            await ndef.write(NdefMessage([NdefRecord.createText(writtenData)]));
            AppSnackBar(AppStrings.dataWriteSuccessfully);
          } else {
            AppSnackBar(AppStrings.dataMaxSizeIsGreaterThanTagSize);
          }
        }
      } else if (tag.data.containsKey('ndefformatable')) {
        AppSnackBar(AppStrings.tagIsNotNDEFFormatType);
      } else {
        AppSnackBar(AppStrings.unknownTagFormatType);
      }
    } catch (e) {
      AppSnackBar(AppStrings.somethingWentWrong);
    } finally {
      _sheetController?.close();
      setState(() {
        _selectedBlockIndex = null;
        _selectedSectorIndex = null;
        _isVisibleBackButton = true;
        _isVisibleBottomNavBar = true;
      });
    }
  }
}
