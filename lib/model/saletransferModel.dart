import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../source/source.dart';
import 'package:http/http.dart' as http;

class SaleTransferModel {
  String? resultCode;
  String? resultMessage;
String? billNo;
  SaleTransferModel({this.resultCode, this.resultMessage, this.billNo});

  SaleTransferModel.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultMessage = json['resultMessage'];
    billNo = json['billNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultCode'] = this.resultCode;
    data['resultMessage'] = this.resultMessage;
    data['billNo'] = this.billNo;
    return data;
  }

  // static Future<SaleTransferModel> SaleTransfer(
  //     {required String Passkey,
  //     required int userId,
  //     required int merchantId,
  //     required String transactionNo,
  //     required String cardRegId,
  //     required String transactionDate,
  //     required String cardNumber,
  //     required double beforeBalance,
  //     required double transactionAmount}) async {
  //   final response = await http.post(Uri.parse('$url/Sale/SaleTransfer'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         "Passkey": Passkey,
  //         "userId": userId,
  //         "merchantId": merchantId,
  //         "transactionNo": transactionNo,
  //         "cardRegId": cardRegId,
  //         "transactionDate": transactionDate,
  //         "cardNumber": cardNumber,
  //         "beforeBalance": beforeBalance,
  //         "transactionAmount": transactionAmount
  //       }));

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     final res = SaleTransferModel.fromJson(jsonDecode(response.body));

  //     if (res == null) {
  //       Fluttertoast.showToast(
  //         msg: "ບໍ່ສຳເລັດ",
  //         toastLength: Toast.LENGTH_SHORT,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         fontSize: 20.0,
  //       );
  //     }
  //     if (res.resultCode != "OK" && res.resultCode != "005") {
  //       print("responseSaleTransfer -> ${res.resultMessage}");
  //       Fluttertoast.showToast(
  //         msg: "${res.resultMessage}",
  //         toastLength: Toast.LENGTH_SHORT,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         fontSize: 20.0,
  //       );
  //     }
  //     if (res.resultCode == "OK" || res.resultCode == "005") {
  //       print("responseSaleTransfer -> ${response.body}");
       
  //     }
  //     return res;
  //   } else {
  //     // print(response.statusCode);
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }
}
