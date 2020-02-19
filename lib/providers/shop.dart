import 'package:flutter/foundation.dart';

class Shop extends ChangeNotifier {
  int _gems = 0;
  int _bills = 999;
  int _billsPerClick = 1;

  int get gems => _gems;
  int get bills => _bills;

  void clickOnDumpling() {
    _bills += _billsPerClick;
    notifyListeners();
  }
}
