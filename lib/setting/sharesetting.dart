import 'package:shared_preferences/shared_preferences.dart';

class SettingShareService {
  static SharedPreferences? preferences;
  static String hasPrinterKey = "hasPrinter";
  static String enablePrinterOrderKey = 'enablePrinterOrder';
  static String enablePrinterPaymentKey = 'enablePrinterPayment';
  static String countPrinntBillKey = 'countPrintBill';
  static String translateCodeKey = 'translateCode';
  static String translateKey = 'translate';
  static String menuLanguageCodeKey = 'menuLanguageCode';
  static String menuLanguageKey = 'menuLanguage';

  static Future init() async =>
      preferences = await SharedPreferences.getInstance();

//Todo: Printer
  static Future setHasPrinter(bool hasPrinter) async =>
      preferences?.setBool(hasPrinterKey, hasPrinter);

  static bool? getHasPrinter() => preferences?.getBool(hasPrinterKey);

  static Future setEnablePrinterOrder(bool enablePrinter) async =>
      preferences?.setBool(enablePrinterOrderKey, enablePrinter);
  static bool? getEnablePrinterOrder() =>
      preferences?.getBool(enablePrinterOrderKey);

  static Future setEnablePrinterPayment(bool enablePrinter) async =>
      preferences?.setBool(enablePrinterPaymentKey, enablePrinter);
  static bool? getEnablePrinterPayment() =>
      preferences?.getBool(enablePrinterPaymentKey);

  static Future setCountPrintBill(int count) async =>
      preferences?.setInt(countPrinntBillKey, count);

  static int? getCountPrintBill() => preferences?.getInt(countPrinntBillKey);

  //Todo: Translate Languages
  static Future setTranslateCode(String languageCode) async =>
      preferences?.setString(translateCodeKey, languageCode);
  static String getTranslateCode() =>
      preferences?.getString(translateCodeKey) ?? 'lo';

  static Future setTranslateLang(String language) async =>
      preferences?.setString(translateKey, language);
  static String? getTranslateLang() => preferences?.getString(translateKey);

  //Todo: Translate Languages
  static Future setMenuLanguageCode(String languageCode) async =>
      preferences?.setString(menuLanguageCodeKey, languageCode);
  static String getMenuLanguageCode() =>
      preferences?.getString(menuLanguageCodeKey) ??
      preferences?.getString(translateKey) ??
      'lo';

  static Future setMenuLanguage(String language) async =>
      preferences?.setString(menuLanguageKey, language);
  static String getMenuLanguage() =>
      preferences?.getString(menuLanguageKey) ??
      preferences?.getString(translateKey) ??
      'ລາວ';
}
