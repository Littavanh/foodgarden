import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../source/source.dart';

class NotiAutoPrint extends StatefulWidget {
  const NotiAutoPrint(
      {super.key,
      required this.transactionId,
      required this.merchantId,
      required this.cardNo,
      required this.billNo,
      required this.saleAmount,
      required this.totalBalance,
      required this.saleDate});
  final String transactionId;
  final String merchantId;
  final String cardNo;
  final String billNo;
  final String saleAmount;
  final String totalBalance;
  final String saleDate;
  @override
  State<NotiAutoPrint> createState() => _NotiAutoPrintState();
}

class _NotiAutoPrintState extends State<NotiAutoPrint> {
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";

  Future<void> printSlip(
   {required String companyName,
  required String transactionId ,
   required String merchantId,
   required String cardNo,
   required String billNo,
   required String saleAmount,
   required String totalBalance,
   required String saleDate}
  ) async {
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

    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.exitTransactionPrint(true);
    Navigator.pop(context);
  }

  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  void initState() {
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
  
    printSlip(companyName: lcompanyName,transactionId: widget.transactionId,merchantId: widget.merchantId,cardNo: widget.cardNo,billNo: widget.billNo,saleAmount: widget.saleAmount,totalBalance: widget.totalBalance,saleDate: widget.saleDate);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("ກຳລັງພິມບິນ")),
    );
  }
}
