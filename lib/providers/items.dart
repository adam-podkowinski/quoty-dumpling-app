import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/models/item.dart';

class ShopItems extends ChangeNotifier {
  List<ShopItem> _items = [];
  List<ShopItem> get items => [..._items];

  Future fetchItems() async {
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
    });
  }
}
