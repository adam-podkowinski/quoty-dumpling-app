import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';
import 'package:quoty_dumpling_app/models/items/money_item.dart';
import 'package:quoty_dumpling_app/models/items/powerup_item.dart';
import 'package:quoty_dumpling_app/models/items/upgrade_item.dart';

class ShopItems extends ChangeNotifier {
  final List<ShopItem> _items = [];
  final List<UpgradeItem> _upgrades = [];

  final List<PowerupItem> _powerups = [];
  final List<MoneyItem> _money = [];

  List<ShopItem> get items => [..._items];
  List<MoneyItem> get money => [..._money];

  List<PowerupItem> get powerups => [..._powerups];
  List<UpgradeItem> get upgrades => [..._upgrades];

  PowerupItem? currentPowerup;

  void addPowerup(powerup) {
    if (currentPowerup == null) {
      currentPowerup = powerup;
      var sub = currentPowerup!.timer.listen(null);
      sub.onData((duration) {
        currentPowerup!.updateTimer(duration.elapsed.inSeconds);
        notifyListeners();
      });
      sub.onDone(() {
        currentPowerup!.deactivatePowerup();
        currentPowerup = null;
        sub.cancel();
        notifyListeners();
      });
    }
  }

  Future fetchItems() async {
    print('fetching items');
    List<dynamic>? content;

    content = jsonDecode(
      await rootBundle.loadString('assets/items/items.json'),
    );

    _items.clear();

    _items.addAll(
      content!.map(
        (e) => ShopItem.fromItemType(e),
      ),
    );

    final dbItems = await DBProvider.db.getAllElements('Items');

    _items.forEach((u) {
      u.fetchFromDB(
        dbItems.firstWhere((e) => e['id'] == u.id, orElse: () => {}),
      );
      switch (u.runtimeType) {
        case UpgradeItem:
          _upgrades.add(u as UpgradeItem);
          break;
        case PowerupItem:
          _powerups.add(u as PowerupItem);
          break;
        default:
          _money.add(u as MoneyItem);
      }
    });
  }
}
