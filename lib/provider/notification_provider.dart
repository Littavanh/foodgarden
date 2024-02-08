import 'package:flutter/material.dart';

class NotificationManager with ChangeNotifier {
  String _loading = '';
  String _postTitle = '';
 
  

  String _adminNotifi = '';

  String _postNotifi = '';

  String get loading => _loading;
  void setLoading(String loading) {
    _loading = loading;
    notifyListeners();
  }

  String get postTitle => _postTitle;
  void setpostTitle({required String title}) {
    _postTitle = title;
    notifyListeners();
  }

 

  String get adminNotifi => _adminNotifi;
  void setAdminNotifi({required String notifi}) {
    _adminNotifi = notifi;

    notifyListeners();
  }

  

  String get postNotifi => _postNotifi;
  void setPostNotifi({required String notifi}) {
    _postNotifi = notifi;

    notifyListeners();
  }
}
