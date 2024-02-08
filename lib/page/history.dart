import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:foodgarden/model/saleHistoryModel.dart';
import 'package:foodgarden/source/source.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../style/color.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late String _setFromDate;
  late String _setToDate;
  late double _height;
  late double _width;
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();
  TextEditingController _dateFromController = TextEditingController();
  TextEditingController _dateToController = TextEditingController();

  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";

  Future<Null> _selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateFrom,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateFrom = picked;
        _dateFromController.text = DateFormat('yyyy-MM-dd').format(selectedDateFrom);
        print("date from: ${_dateFromController.text}");
      });
  }

  Future<Null> _selectDateTo(BuildContext context) async {
    final DateTime? picked1 = await showDatePicker(
        context: context,
        initialDate: selectedDateTo,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked1 != null)
      setState(() {
        selectedDateTo = picked1;

        // _dateToController.text = DateFormat.yMd().format(selectedDateTo);
        _dateToController.text = DateFormat('yyyy-MM-dd').format(selectedDateTo);
        print(" date to :${_dateToController.text}");
      });
  }

  int? count;
  double balanceCount = 0;
  @override
  void initState() {
    _dateFromController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _dateToController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text('ປະຫວັດການຂາຍ'),
          actions: [
            IconButton(
                onPressed: () async {
// int tal = 0;
//  for (var i = 0; i < res.length; i++) {
//      int balance = res[i].balance!.toInt();
//                   tal = tal + balance;
//   print(res[i].balance);
//  print(res[i].regCard);

//                       }
int tal = 0;
 List res = await DataModel.fecthSaleHistory(
                      Passkey: lotp,
                      userId: lUserId!,
                      startDate: _dateFromController.text,
                      endDate: _dateToController.text,
                      merchantId: int.parse(lmerchantId));
 await SunmiPrinter.initPrinter();
  await  SunmiPrinter.startTransactionPrint(true);
   await SunmiPrinter.printText(
      "ໃບບິນສະຫຼຸບການຂາຍ",
      style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
          bold: true,
          fontSize: SunmiFontSize.MD),
    );

  await  SunmiPrinter.printText(
      "****************************",
      style:
          SunmiStyle(align: SunmiPrintAlign.CENTER, fontSize: SunmiFontSize.SM),
    );
    //  SunmiPrinter.lineWrap(1);
 await   SunmiPrinter.printText(
      "ແຕ່ວັນທີ: ${_dateFromController.text}",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
  await  SunmiPrinter.printText(
      "ຫາວັນທີ: ${_dateToController.text}",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
 

  await  SunmiPrinter.lineWrap(1);
   await SunmiPrinter.printText(
      "ລາຍລະອຽດ: -------------------",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
      
                      for (var item in res) {
                         int balance = item.balance.toInt();
                  tal = tal + balance;
   await SunmiPrinter.printText(
      "Bill No:#${item.billNo},RegCard:${item.regCard},CardId:${item.cardId}",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
  await  SunmiPrinter.printText(
      "ວັນທີ: ${item.dateAdd}",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
   
  await  SunmiPrinter.printText(
      "ລາຄາ ${NumberFormat.decimalPattern().format(item.balance)} ກີບ",
      style: SunmiStyle(
        align: SunmiPrintAlign.RIGHT,
        fontSize: SunmiFontSize.MD,
      ),
    );
         }
      await SunmiPrinter.printText(
      "-----------------------------",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
     await  SunmiPrinter.printText(
      "ຈຳນວນລາຍການ: ${res.length}",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD, bold: true,),
    );
  await  SunmiPrinter.printText(
      "ລວມຍອດ: ${NumberFormat.decimalPattern().format(tal)} ກີບ",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD, bold: true,),
    );
   


                       
                 

                       SunmiPrinter.lineWrap(3);
    SunmiPrinter.exitTransactionPrint(true);
                },
                tooltip: 'Upload',
                icon: const Icon(Icons.download_rounded, color: iconColor)),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder<List<DataModel>>(
            future: DataModel.fecthSaleHistory(
                Passkey: lotp,
                userId: lUserId!,
                startDate: _dateFromController.text,
                endDate: _dateToController.text,
                merchantId: int.parse(lmerchantId)),
            builder: (context, AsyncSnapshot<List<DataModel>> snapshot) {
              if (snapshot.hasData) {
                List<DataModel> saleHis = snapshot.data as List<DataModel>;
                int total = 0;
                for (var i = 0; i < saleHis.length; i++) {
                  int? balance = saleHis[i].balance!.toInt();
                  total = total + balance;
                  // print("total : ${NumberFormat.decimalPattern().format(total)}");
                }
                return Column(
                  children: [
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 60,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: const Text(
                                  "ຈາກວັນທີ:",
                                  style: TextStyle(fontSize: 16),
                                )),
                            InkWell(
                              onTap: () {
                                _selectDateFrom(context);
                              },
                              child: Container(
                                width: 80,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _dateFromController,
                                  onSaved: (String? val) {
                                    _setFromDate = val!;
                                  },
                                  decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                                width: 60,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: const Text(
                                  "ຫາວັນທີ:",
                                  style: TextStyle(fontSize: 16),
                                )),
                            InkWell(
                              onTap: () {
                                _selectDateTo(context);
                              },
                              child: Container(
                                width: 80,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _dateToController,
                                  onSaved: (String? val) {
                                    _setToDate = val!;
                                  },
                                  decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: saleHis.length,
                          itemBuilder: (context, index) {
                            count = index + 1;

                            String date = saleHis[index].dateAdd.toString();
                            var datetime = DateTime.parse(date);
                            var outputFormat =
                                DateFormat('MM-dd-yyyy hh:mm:ss');
                            var outputDate = outputFormat.format(datetime);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Text(count.toString()),
                              ),
                              title:
                                  Text('# ${saleHis[index].billNo.toString()}'),
                              trailing: Text(
                                NumberFormat.decimalPattern()
                                    .format(saleHis[index].balance),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(outputDate.toString()),
                            );
                          }),
                    ),
                    Column(children: [
                      Container(
                        width: 350,
                        height: 30,
                        alignment: Alignment.centerLeft,
                        child: Text("ຈຳນວນ ${saleHis.length} ລາຍການ"),
                      ),
                      Container(
                        width: 350,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "ລວມ : ${NumberFormat.decimalPattern().format(total)} ກີບ",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      )
                    ]),
                  ],
                );
              }

              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 60,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: const Text(
                              "ຈາກວັນທີ:",
                              style: TextStyle(fontSize: 16),
                            )),
                        InkWell(
                          onTap: () {
                            _selectDateFrom(context);
                          },
                          child: Container(
                            width: 80,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _dateFromController,
                              onSaved: (String? val) {
                                _setFromDate = val!;
                              },
                              decoration: const InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                            width: 60,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: const Text(
                              "ຫາວັນທີ:",
                              style: TextStyle(fontSize: 16),
                            )),
                        InkWell(
                          onTap: () {
                            _selectDateTo(context);
                          },
                          child: Container(
                            width: 80,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _dateToController,
                              onSaved: (String? val) {
                                _setToDate = val!;
                              },
                              decoration: const InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ບໍ່ມີປະຫວັດການຂາຍລະຫວ່າງ ",
                              style: const TextStyle(fontSize: 20)),
                          Text(
                              "ວັນທີ ${_dateFromController.text} ຫາ ${_dateToController.text}",
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }

  Future<void> printSlip() async {

  
    SunmiPrinter.initPrinter();
    SunmiPrinter.startTransactionPrint(true);
    SunmiPrinter.printText(
      "ໃບບິນສະຫຼຸບການຂາຍ",
      style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
          bold: true,
          fontSize: SunmiFontSize.MD),
    );

    SunmiPrinter.printText(
      "****************************",
      style:
          SunmiStyle(align: SunmiPrintAlign.CENTER, fontSize: SunmiFontSize.SM),
    );
    //  SunmiPrinter.lineWrap(1);
    SunmiPrinter.printText(
      "ແຕ່ວັນທີ: ${_dateFromController.text}",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    SunmiPrinter.printText(
      "ຫາວັນທີ: ${_dateToController.text}",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    SunmiPrinter.printText(
      "ຈຳນວນລາຍການ: ",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    SunmiPrinter.printText(
      "ລວມຍອດ: ",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );

    SunmiPrinter.lineWrap(1);
    SunmiPrinter.printText(
      "ລາຍລະອຽດ: -------------------",
      style:
          SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    );
    // SunmiPrinter.printText(
    //   "Bill No:#$billNo,RegCard:$regCard,CardId:$cardId",
    //   style:
    //       SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    // );
    // SunmiPrinter.printText(
    //   "ວັນທີ: $date",
    //   style:
    //       SunmiStyle(align: SunmiPrintAlign.LEFT, fontSize: SunmiFontSize.MD),
    // );
    // SunmiPrinter.printText(
    //   "ລາຄາ $amount",
    //   style: SunmiStyle(
    //     align: SunmiPrintAlign.RIGHT,
    //     fontSize: SunmiFontSize.MD,
    //   ),
    // );
    SunmiPrinter.lineWrap(3);
    SunmiPrinter.exitTransactionPrint(true);
  }
}
