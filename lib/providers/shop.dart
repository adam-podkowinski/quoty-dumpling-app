import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Shop extends ChangeNotifier {
  int _diamonds = 0;
  int _bills = 999;
  int _billsPerClick = 1;

  int get diamonds => _diamonds;
  int get bills => _bills;

  void clickOnDumpling() {
    _bills += _billsPerClick;
    notifyListeners();
  }

  void openDumpling() {
    _bills += _billsPerClick * 100;
    _diamonds += 20;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => notifyListeners(),
    );
  }

  void buyItem({int priceInBills = 0, int priceInDiamond = 0}) {
    if (priceInBills <= _bills && priceInDiamond <= _diamonds) {
      _bills -= priceInBills;
      _diamonds -= priceInDiamond;
      notifyListeners();
    }
  }
}
