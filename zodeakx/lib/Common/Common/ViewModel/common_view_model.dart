import 'package:flutter/material.dart';

class CommonViewModel extends ChangeNotifier {
  /// Bottom Navigation bar onChanged value using provider
  int id = 0;
  bool noInternet = false;
  bool needToLoad = false;
  Widget? drawer;
  TextEditingController searchPairController = TextEditingController();

  CommonViewModel() {
    setConstValue();
    setLoading(false);
  }

  setConstValue() {}

  Future<void> setActive(int index, [bool searchTrigger = false]) async {
    id = index;
    notifyListeners(); //  Consumer to rebuild
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Drawer
  setDrawer(Widget? widget) async {
    drawer = widget;
    notifyListeners();
  }
}
