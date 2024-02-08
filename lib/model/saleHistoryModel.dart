// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../source/source.dart';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  DataModel({
    this.transactionNo,
    this.regCard,
    this.cardId,
    this.memberId,
    this.merchantId,
    this.accountBalance,
    this.balance,
    this.depositAmount,
    this.totalBalance,
    this.percentM,
    this.tranTypeId,
    this.remark,
    this.posSn,
    this.userAdd,
    this.dateAdd,
    this.billNo,
  });

  String? transactionNo;
  int? regCard;
  int? cardId;
  dynamic memberId;
  int? merchantId;
  double? accountBalance;
  double? balance;
  double? depositAmount;
  double? totalBalance;
  double? percentM;
  int? tranTypeId;
  String? remark;
  String? posSn;
  int? userAdd;
  String? dateAdd;
  String? billNo;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        transactionNo: json["transactionNo"],
        regCard: json["reg_card"],
        cardId: json["cardId"],
        memberId: json["memberId"],
        merchantId: json["merchantId"],
        accountBalance: json["account_balance"],
        balance: json["balance"],
        depositAmount: json["deposit_amount"],
        totalBalance: json["total_balance"],
        percentM: json["Percent_M"],
        tranTypeId: json["TranTypeId"],
        remark: json["remark"],
        posSn: json["POS_SN"],
        userAdd: json["user_add"],
        dateAdd: json["date_add"],
        billNo: json["billNo"],
      );

  Map<String, dynamic> toJson() => {
        "transactionNo": transactionNo,
        "reg_card": regCard,
        "cardId": cardId,
        "memberId": memberId,
        "merchantId": merchantId,
        "account_balance": accountBalance,
        "balance": balance,
        "deposit_amount": depositAmount,
        "total_balance": totalBalance,
        "Percent_M": percentM,
        "TranTypeId": tranTypeId,
        "remark": remark,
        "POS_SN": posSn,
        "user_add": userAdd,
        "date_add": dateAdd,
        "billNo": billNo,
      };
  static Future getURL() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getString('url') != null) {
      return sharedPref.getString('url');
    }
    return UrlConstants.initURL;
  }

  static Future<List<DataModel>> fecthSaleHistory({
    required String Passkey,
    required int userId,
    required String startDate,
    required String endDate,
    required int merchantId,
  }) async {
    final url = await getURL();
    final response = await http.post(Uri.parse('$url/Sale/SaleHistory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Passkey": Passkey,
          "userId": userId,
          "startDate": startDate,
          "endDate": endDate,
          "merchantId": merchantId,
        }));
    print("body: ${jsonEncode({
          "Passkey": Passkey,
          "userId": userId,
          "startDate": startDate,
          "endDate": endDate,
          "merchantId": merchantId,
        })}");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      final json = jsonDecode(response.body);
      List<DataModel> data = List<DataModel>.from(
          (json['data']).map((x) => DataModel.fromJson(x)));

      return data;
    } else {
      // print(response.statusCode);
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
