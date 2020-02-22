import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shop extends ChangeNotifier {
  int _diamonds = 0;
  int _bills = 0;
  int _billsPerClick = 1;

  int get diamonds => _diamonds;
  int get bills => _bills;

  Future initShop() async {
    final prefs = await SharedPreferences.getInstance();
    _bills = prefs.getInt('bills') ?? 0;
    _diamonds = prefs.getInt('diamonds') ?? 0;
    _billsPerClick = prefs.getInt('billsPerClick') ?? 1;
  }

  void clickOnDumpling() {
    _bills += _billsPerClick;
    notifyListeners();

    SharedPreferences.getInstance().then(
      (prefs) => prefs.setInt('bills', _bills),
    );
  }

  void openDumpling() {
    _bills += _billsPerClick * 100;
    _diamonds += 20;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => notifyListeners(),
    );

    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setInt('bills', _bills);
        prefs.setInt('diamonds', _diamonds);
      },
    );
  }

  void buyItem({int priceInBills = 0, int priceInDiamond = 0}) {
    if (priceInBills <= _bills && priceInDiamond <= _diamonds) {
      _bills -= priceInBills;
      _diamonds -= priceInDiamond;
      notifyListeners();

      SharedPreferences.getInstance().then(
        (prefs) {
          prefs.setInt('bills', _bills);
          prefs.setInt('diamonds', _diamonds);
        },
      );
    }
  }
}
