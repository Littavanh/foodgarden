
import 'package:encrypt/encrypt.dart';

import '../setting/sharesetting.dart';

class RememberMe {
  static String userNameKey = "userName";
  static String passwordKey = "password";
  static String rememberMeKey = "rememberMe";

  String username;
  String password;
  bool remember;
  RememberMe({
    required this.username,
    required this.password,
    required this.remember,
  });

  Future setUser() async {
    await SettingShareService.preferences?.setString(userNameKey, username);
    await SettingShareService.preferences
        ?.setString(passwordKey, encryptPassword(plainText: password));
    await SettingShareService.preferences?.setBool(rememberMeKey, remember);
  }

  static RememberMe getUser() {
    return RememberMe(
        username: SettingShareService.preferences?.getString(userNameKey) ?? '',
        password: decryptPassword(
            encryptText:
                SettingShareService.preferences?.getString(passwordKey) ?? ''),
        remember:
            SettingShareService.preferences?.getBool(rememberMeKey) ?? false);
  }

//Todo: encrypter and decrypter password
  static final key = Key.fromLength(32);
  static final iv = IV.fromLength(8);
  static final encrypter = Encrypter(Salsa20(key));

  static String encryptPassword({required String plainText}) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decryptPassword({required String encryptText}) {
    final decrypted = encrypter.decrypt64(encryptText, iv: iv);
    return decrypted;
  }
}
