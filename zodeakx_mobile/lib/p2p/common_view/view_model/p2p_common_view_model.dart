import 'package:flutter/material.dart';

class P2PCommonViewModel extends ChangeNotifier {
  /// Bottom Navigation bar onChanged value using provider
  int id = 0;
  bool noInternet = false;
  bool needToLoad = false;

  P2PCommonViewModel() {
  }

  Future<void> setActive(int index) async {
    id = index;
    notifyListeners(); //  Consumer to rebuild
  }

  clearData() {
    id = 0;
    noInternet = false;
    needToLoad = false;
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }
}
