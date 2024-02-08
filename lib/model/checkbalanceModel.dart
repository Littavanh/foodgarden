import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config/common/widget/app_snackbar.dart';
import '../main.dart';
import '../source/source.dart';
import 'package:http/http.dart' as http;

class CheckBalanceModel {
  int? statusCode;
  double? cardTotalBalance;

  CheckBalanceModel({this.statusCode, this.cardTotalBalance});

  CheckBalanceModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    cardTotalBalance = json['cardTotalBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['cardTotalBalance'] = this.cardTotalBalance;
    return data;
  }
 static Future getURL() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getString('url') != null) {
      return sharedPref.getString('url');
    }
    return UrlConstants.initURL;
  }
  static Future<CheckBalanceModel> fetchCheckBalance(
      {required String Passkey,required String userId,required String cardUId}) async {
        final url = await getURL();
    final response = await http.post(Uri.parse('$url/Card/checkBalance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"Passkey": Passkey,
  "userId": userId,'cardUId': cardUId}));

    if (response.statusCode == 200) {
      final check = CheckBalanceModel.fromJson(jsonDecode(response.body));
      LcardTotalBalance = check.cardTotalBalance ?? 0;

      if (check.statusCode == 200) {
        print("response -> ${response.body}");
      }
      if (check.statusCode == 417) {
        print("responseNo -> ${response.body}");
        Fluttertoast.showToast(
          msg: "ລະບົບຜິດພາດ ແຈ້ງປະຊາສຳພັນ",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          fontSize: 20.0,
        );
      }
      if (check.statusCode == 217) {
        print("responseNo -> ${response.body}");
        Fluttertoast.showToast(
          msg: "ບໍ່ໄດ້ລົງທະບຽນບັດ",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          fontSize: 20.0,
        );
      }

      return check;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.

      throw Exception('Failed to load Balance');
    }
  }

  
}
