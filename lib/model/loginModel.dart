import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../source/exception.dart';
import '../source/source.dart';
import 'package:http/http.dart' as http;

class LoginModel {
  int? userId;
  String? resultCode;
  String? resultMessage;
  String? otp;
  String? merchantId;
  String? merchantName;
  String? shopCode;
  String? companyName;
  String? companyTel;
  String? footerNote1;
  String? footerNote2;

  LoginModel(
      {this.userId,
      this.resultCode,
      this.resultMessage,
      this.otp,
      this.merchantId,
      this.merchantName,
      this.shopCode,
      this.companyName,
      this.companyTel,
      this.footerNote1,
      this.footerNote2});

  LoginModel.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    resultCode = json['resultCode'];
    resultMessage = json['resultMessage'];
    otp = json['otp'];
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    shopCode = json['shopCode'];
    companyName = json['companyName'];
    companyTel = json['companyTel'];
    footerNote1 = json['footerNote1'];
    footerNote2 = json['footerNote2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['resultCode'] = this.resultCode;
    data['resultMessage'] = this.resultMessage;
    data['otp'] = this.otp;
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['shopCode'] = this.shopCode;
    data['companyName'] = this.companyName;
    data['companyTel'] = this.companyTel;
    data['footerNote1'] = this.footerNote1;
    data['footerNote2'] = this.footerNote2;
    return data;
  }
 static Future getURL() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getString('url') != null) {
      return sharedPref.getString('url');
    }
    return UrlConstants.initURL;
  }
  static Future<LoginModel> login(
      {required String passkey,
      digitalSignature,
      userName,
      userPassword}) async {
         final url = await getURL();
    final response = await http.post(Uri.parse('$url/User/Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Passkey": passkey,
          "DigitalSignature": digitalSignature,
          "UserName": userName,
          "UserPassword": userPassword
        }));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      final user = LoginModel.fromJson(jsonDecode(response.body));
      lUserId = user.userId ?? 0;
      lotp = user.otp ?? '';
      lmerchantId = user.merchantId ?? '';
      lmerchantName = user.merchantName ?? '';
      lshopCode = user.shopCode ?? '';
      lcompanyName = user.companyName ?? '';
      lfooter = user.footerNote2 ?? '';
      return LoginModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }
}
