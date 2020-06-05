import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/helpers/item_functions.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';

enum ItemType {
  UPGRADE,
  MONEY,
  POWERUP,
}

enum IconType {
  BILLS,
  CLICKS,
}

class ShopItem {
  final String name;
  final String description;
  final int defaultPriceBills;
  final int defaultPriceDiamonds;
  final int priceUSD;
  final Function function;
  final String id;
  final ItemType type;
  final IconType iconType;

  int _level;
  int get level => _level;

  int actualPriceBills;
  int actualPriceDiamonds;

  ShopItem._({
    this.name,
    this.description,
    this.defaultPriceBills,
    this.defaultPriceDiamonds,
    this.priceUSD,
    this.function,
    this.id,
    this.actualPriceBills,
    this.actualPriceDiamonds,
    this.type,
    this.iconType,
  }) {
    actualPriceBills = defaultPriceBills;
    actualPriceDiamonds = defaultPriceDiamonds;
  }

  factory ShopItem.fromMap(Map<String, dynamic> map) {
    return ShopItem._(
      name: map['name'],
      description: map['description'],
      defaultPriceBills: map['defaultPriceBills'],
      defaultPriceDiamonds: map['defaultPriceDiamonds'],
      priceUSD: map['priceUSD'],
      id: map['id'],
      type: typeFromString(map['type']),
      iconType: iconTypeFromString(map['iconType']),
    );
  }

  static ItemType typeFromString(String type) {
    switch (type) {
      case 'upgrade':
        return ItemType.UPGRADE;
      case 'money':
        return ItemType.MONEY;
      default:
        return ItemType.POWERUP;
    }
  }

  IconData itemTypeIcon() {
    switch (iconType) {
      case IconType.BILLS:
        {
          return CustomIcons.dollar;
        }
      default:
        {
          return CustomIcons.click;
        }
    }
  }

  static IconType iconTypeFromString(String iType) {
    switch (iType) {
      case 'bills':
        return IconType.BILLS;
      case 'clicks':
        return IconType.CLICKS;
    }
    return null;
  }

  void fetchFromDB(Map<String, dynamic> map) {
    _level = map.isEmpty ? 1 : map['level'];

    refreshActualPrices();
  }

  void refreshActualPrices() {
    actualPriceBills = (defaultPriceBills * (pow(1.3, _level))).round();
    actualPriceDiamonds = (defaultPriceDiamonds * (pow(1.3, _level))).round();
  }

  void buyItem(context) {
    switch (id) {
      case '001':
        ItemFunctions.increaseBillsOnClickByOne(context);
        break;
      case '002':
        ItemFunctions.increaseClickMultiplierByLow(context);
        break;
      case '003':
        ItemFunctions.increaseCashOnOpeningMultiplier(context);
        break;
    }
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
}
