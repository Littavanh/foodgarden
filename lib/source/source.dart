




// const String url = 'http://172.2.0.200:8245/api/'; //real

import 'package:shared_preferences/shared_preferences.dart';

// const String url = 'http://192.168.100.28:8245/api/'; //test

 String PASS_KEY = "a486f489-76c0-4c49-8ff0-d0fdec0a162b";

//  var WALLET_BLOCK = 4 * 4;
//  var WALLET_KEY_A = "123456ABCD12";
//  var WALLET_KEY_DEFAULT = "FFFFFFFFFFFF";
//  var CARDNO_BLOCK = (5 * 4) + 2;
//  var CARDREG_BLOCK = (4 * 4) + 1;
//  var DEPOSIT_BLOCK = (4 * 4) + 2;

int? lUserId = 0;
String lotp = "";
String lmerchantId = "";
String lmerchantName = "";
String lshopCode = "";
String lcompanyName = "";
String lfooter = "";
 double LcardTotalBalance=0;




bool isNumeric(String str) {
  try {
    if (str.isEmpty) {
      return false;
    }
    return double.tryParse(str) != null;
  } on Exception {
    return false;
  }
}

double convertPattenTodouble(String value) {
  String str = '0';
  for (int i = 0; i < value.length; i++) {
    if (value[i].isNotEmpty && value[i] != ',' && isNumeric(value[i]) ||
        value[i] == '.') {
      str += value[i];
    }
  }
  return double.parse(str);
}
 setSettingButton() async {
    var pref = await SharedPreferences.getInstance();

    var num_1 = (pref.getString('num_1') ?? "1000");
    var num_2 = (pref.getString('num_2') ?? "5000");
    var num_3 = (pref.getString('num_3') ?? "10000");
    var num_4 = (pref.getString('num_4') ?? "15000");
    var num_5 = (pref.getString('num_5') ?? "20000");
    var num_6 = (pref.getString('num_6') ?? "30000");
    var num_7 = (pref.getString('num_7') ?? "50000");
    var num_8 = (pref.getString('num_8') ?? "70000");
    var num_9 = (pref.getString('num_9') ?? "100000");
    var print_count = (pref.getInt('print_count') ?? 1);
    var url = (pref.getString('url') ?? UrlConstants.initURL);
    pref.setString("num_1", num_1);
    pref.setString("num_2", num_2);
    pref.setString("num_3", num_3);
    pref.setString("num_4", num_4);
    pref.setString("num_5", num_5);
    pref.setString("num_6", num_6);
    pref.setString("num_7", num_7);
    pref.setString("num_8", num_8);
    pref.setString("num_9", num_9);
    pref.setInt("print_count", print_count);
    pref.setString("url", url);
    
    print("setSettingButton ===> button2: $num_2 ,url: $url");
 }

class UrlConstants {
  static String initURL = 'http://172.2.0.200:8899/api/'; //real
// static const String initURL = "http://192.168.100.28:8245/api/";
  
}
