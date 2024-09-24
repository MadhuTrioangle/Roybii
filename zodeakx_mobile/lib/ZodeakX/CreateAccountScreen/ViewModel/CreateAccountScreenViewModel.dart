import 'package:flutter/cupertino.dart';

class CreateAccountViewModel extends ChangeNotifier {
  int activePage = 0;
  PageController? pageController;

  Future<void> setActivePage(int index) async {
    activePage = index;
    notifyListeners(); //  Consumer to rebuild
  }
}
