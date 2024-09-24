import 'package:flutter/cupertino.dart';

class LaunchPadCommonViewModel extends ChangeNotifier{
  /// Bottom Navigation bar onChanged value using provider
  int id = 0;

  Future<void> setActive(int index) async {
    id = index;
    notifyListeners(); //  Consumer to rebuild
  }
}