import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/models/achievement.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';
import 'package:quoty_dumpling_app/models/items/powerup_item.dart';
import 'package:quoty_dumpling_app/providers/items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shop extends ChangeNotifier {
  int _diamonds = 0;
  int _bills = 0;
  int _billsPerClick = 1;
  double _cashMultiplierOnOpening = 1.5;

  int _billsOnOpening;
  int get bills => _bills;
  int get billsOnOpening => _billsOnOpening;
  int get billsPerClick => _billsPerClick;
  int get diamonds => _diamonds;

  void receiveAchievement(Achievement a) {
    _bills += a.billsReward;
    _diamonds += a.diamondsReward;
    notifyListeners();
  }

  void buyItem(ShopItem item, context) {
    if (item.actualPriceBills <= _bills &&
        item.actualPriceDiamonds <= _diamonds) {
      _bills -= item.actualPriceBills;
      _diamonds -= item.actualPriceDiamonds;

      item.buyItem(context);

      notifyListeners();

      SharedPreferences.getInstance().then(
        (prefs) {
          prefs.setInt('bills', _bills);
          prefs.setInt('diamonds', _diamonds);
        },
      );
    }
  }

  void changeBillsOnClick(int howMuch) {
    _billsPerClick += howMuch;

    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setInt('billsPerClick', _billsPerClick);
      },
    );
  }

  void changeCashMultiplierOnOpening(double howMuch) {
    _cashMultiplierOnOpening += howMuch;
    _updateBillsOnOpening();
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setDouble('cashMultiplierOnOpening', _cashMultiplierOnOpening);
      },
    );
  }

  bool checkIsActiveItem(ShopItem item, context) {
    if (item is PowerupItem) {
      if (Provider.of<ShopItems>(context, listen: false).currentPowerup !=
          null) {
        return false;
      }
    }
    if (item.actualPriceBills > _bills ||
        item.actualPriceDiamonds > _diamonds) {
      return false;
    } else {
      return true;
    }
  }

  void clickOnDumpling() {
    _bills += _billsPerClick;
    notifyListeners();

    SharedPreferences.getInstance().then(
      (prefs) => prefs.setInt('bills', _bills),
    );
  }

  Future initShop() async {
    final prefs = await SharedPreferences.getInstance();
    _bills = prefs.getInt('bills') ?? 0;
    _diamonds = prefs.getInt('diamonds') ?? 0;
    _billsPerClick = prefs.getInt('billsPerClick') ?? 1;
    _cashMultiplierOnOpening =
        prefs.getDouble('cashMultiplierOnOpening') ?? 1.5;
    _updateBillsOnOpening();

    //* init (debug)
    //_bills = 0;
    //_diamonds = 0;
  }

  static String numberAbbreviation(int number) {
    var nLen = number.toString().length;
    var text = '';

    bool changeText(String abbreviation, int x) {
      //! Really messy algorithm, just makes text shorter
      if (nLen > x && nLen < x + 4) {
        for (var i = 0; i < nLen - x; i++) {
          text += number.toString()[i];
        }
        if (!(number.toString()[nLen - x] == '0' &&
            number.toString()[nLen - (x - 1)] == '0')) {
          text += '.';
          text += number.toString()[nLen - x];
          if (!(number.toString()[nLen - (x - 1)] == '0')) {
            text += number.toString()[nLen - (x - 1)];
          }
        }
        text += abbreviation;
        return true;
      }
      return false;
    }

    if (!changeText('K', 3) &&
        !changeText('M', 6) &&
        !changeText('B', 9) &&
        !changeText('q', 12)) {
      text = number.toString();
    }

    return text;
  }

  void openDumpling() {
    _bills += _billsOnOpening;
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

  void _updateBillsOnOpening() {
    _billsOnOpening = _billsPerClick * (_cashMultiplierOnOpening * 100).toInt();
  }
}
