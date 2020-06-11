import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';
import 'package:quoty_dumpling_app/models/items/moneyItem.dart';
import 'package:quoty_dumpling_app/models/items/powerupItem.dart';
import 'package:quoty_dumpling_app/models/items/upgradeItem.dart';

class ShopItems extends ChangeNotifier {
  List<ShopItem> _items = [];
  List<UpgradeItem> _upgrades = [];

  List<PowerupItem> _powerups = [];
  List<MoneyItem> _money = [];

  List<ShopItem> get items => [..._items];
  List<MoneyItem> get money => [..._money];

  List<PowerupItem> get powerups => [..._powerups];
  List<UpgradeItem> get upgrades => [..._upgrades];

  PowerupItem currentPowerup;

  void addPowerup(powerup) {
    if (currentPowerup == null) {
      currentPowerup = powerup;
      var sub = currentPowerup.timer.listen(null);
      sub.onData((duration) {
        currentPowerup.updateTimer(duration.elapsed.inSeconds);
        notifyListeners();
      });
      sub.onDone(() {
        currentPowerup.deactivatePowerup();
        currentPowerup = null;
        sub.cancel();
        notifyListeners();
      });
    }
  }

  Future fetchItems() async {
    print('fetching');
    List<dynamic> content;

    content = jsonDecode(
      await rootBundle.loadString('assets/items/items.json'),
    );

    _items.clear();

    _items.addAll(
      content.map((e) {
        return ShopItem.fromItemType(e);
      }),
    );

    final dbItems = await DBProvider.db.getAllElements('Items');

    _items.forEach((u) {
      u.fetchFromDB(
        dbItems.firstWhere((e) => e['id'] == u.id, orElse: () => Map()),
      );
      switch (u.runtimeType) {
        case UpgradeItem:
          _upgrades.add(u);
          break;
        case PowerupItem:
          _powerups.add(u);
          break;
        default:
          _money.add(u);
      }
    });
  }
}
