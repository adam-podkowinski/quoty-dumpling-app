import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/models/item.dart';

class ShopItems extends ChangeNotifier {
  List<ShopItem> _items = [];
  List<ShopItem> get items => [..._items];

  List<ShopItem> _upgrades = [];
  List<ShopItem> get upgrades => [..._upgrades];

  List<ShopItem> _money = [];
  List<ShopItem> get money => [..._money];

  List<ShopItem> _powerups = [];
  List<ShopItem> get powerups => [..._powerups];

  Future fetchItems() async {
    print('fetching');
    List<dynamic> content;

    content = jsonDecode(
      await rootBundle.loadString('assets/items/items.json'),
    );

    _items.clear();

    _items.addAll(
      content.map(
        (e) => ShopItem.fromMap(e),
      ),
    );

    final dbItems = await DBProvider.db.getAllElements('Items');

    _items.forEach((u) {
      u.fetchFromDB(
        dbItems.firstWhere((e) => e['id'] == u.id, orElse: () => Map()),
      );

      switch (u.type) {
        case ItemType.UPGRADE:
          {
            _upgrades.add(u);
          }
          break;
        case ItemType.MONEY:
          {
            _money.add(u);
          }
          break;
        default:
          {
            _powerups.add(u);
          }
      }
    });
  }
}
