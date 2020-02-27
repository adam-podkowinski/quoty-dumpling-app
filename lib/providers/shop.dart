import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quoty_dumpling_app/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shop extends ChangeNotifier {
  int _diamonds = 0;
  int _bills = 0;
  int _billsPerClick = 1;
  double _cashMultiplierOnOpening = 1.5;

  int get diamonds => _diamonds;
  int get bills => _bills;

  Future initShop() async {
    final prefs = await SharedPreferences.getInstance();
    _bills = prefs.getInt('bills') ?? 0;
    _diamonds = prefs.getInt('diamonds') ?? 0;
    _billsPerClick = prefs.getInt('billsPerClick') ?? 1;
    _cashMultiplierOnOpening =
        prefs.getDouble('cashMultiplierOnOpening') ?? 1.5;
  }

  void clickOnDumpling() {
    _bills += _billsPerClick;
    notifyListeners();

    SharedPreferences.getInstance().then(
      (prefs) => prefs.setInt('bills', _bills),
    );
  }

  void openDumpling() {
    _bills += _billsPerClick * (_cashMultiplierOnOpening * 100).toInt();
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

  void buyItem(ShopItem item, context) {
    if (item.actualPriceBills <= _bills &&
        item.actualPriceDiamonds <= _diamonds) {
      _bills -= item.actualPriceBills;
      _diamonds -= item.actualPriceDiamonds;

      item.useItem(context);

      notifyListeners();

      SharedPreferences.getInstance().then(
        (prefs) {
          prefs.setInt('bills', _bills);
          prefs.setInt('diamonds', _diamonds);
        },
      );
    }
  }

  //! ITEM FUNCTIONS

  void increaseBillsOnClick(int howMuch) {
    _billsPerClick += howMuch;

    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setInt('billsPerClick', _billsPerClick);
      },
    );
  }

  void increaseCashMultiplierOnOpening(double howMuch) {
    _cashMultiplierOnOpening += howMuch;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setDouble('cashMultiplierOnOpening', _cashMultiplierOnOpening);
      },
    );
  }
}
