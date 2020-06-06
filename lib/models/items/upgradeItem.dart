import 'dart:math';

import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';

class UpgradeItem extends LabeledItem {
  int _level = 0;

  UpgradeItem(map) : super.fromMap(map);

  int get level => _level;

  @override
  void buyItem(context) {
    super.buyItem(context);

    _level++;
    refreshActualPrices();

    DBProvider.db.getElement('Items', id).then((i) {
      if (i.isEmpty)
        DBProvider.db.insert(
          'Items',
          {'id': id, 'level': _level},
        );
      else
        DBProvider.db.updateElementById(
          'Items',
          id,
          {'level': _level},
        );
    });
  }

  @override
  void fetchFromDB(Map<String, dynamic> map) {
    _level = map.isEmpty ? 1 : map['level'];

    refreshActualPrices();
  }

  @override
  String getLabel() {
    return 'Level: ${_level.toString()}';
  }

  void refreshActualPrices() {
    actualPriceBills = (defaultPriceBills * (pow(1.3, _level))).round();
    actualPriceDiamonds = (defaultPriceDiamonds * (pow(1.3, _level))).round();
  }
}
