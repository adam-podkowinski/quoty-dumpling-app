import 'package:flutter/widgets.dart';
import 'package:quoty_dumpling_app/helpers/item_functions.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';

import 'package:quoty_dumpling_app/models/items/upgradeItem.dart';
import 'package:quoty_dumpling_app/models/items/powerupItem.dart';
import 'package:quoty_dumpling_app/models/items/moneyItem.dart';

enum IconType {
  BILLS,
  CLICKS,
}

abstract class ShopItem {
  String name;
  String description;
  int defaultPriceBills;
  int defaultPriceDiamonds;
  int priceUSD;
  String id;
  IconType iconType;

  int _level;
  int get level => _level;

  int actualPriceBills;
  int actualPriceDiamonds;

  ShopItem.fromMap(map) {
    name = map['name'];
    description = map['description'];
    defaultPriceBills = map['defaultPriceBills'];
    defaultPriceDiamonds = map['defaultPriceDiamonds'];
    priceUSD = map['priceUSD'];
    id = map['id'];
    iconType = iconTypeFromString(map['iconType']);
    actualPriceBills = defaultPriceBills;
    actualPriceDiamonds = defaultPriceDiamonds;
  }

  factory ShopItem.fromItemType(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'upgrade':
        return UpgradeItem(map);
      case 'powerup':
        return PowerupItem(map);
      default:
        return MoneyItem(map);
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

  bool hasLevel() => false;

  void fetchFromDB(Map<String, dynamic> map) {}

  static IconType iconTypeFromString(String iType) {
    switch (iType) {
      case 'bills':
        return IconType.BILLS;
      case 'clicks':
        return IconType.CLICKS;
    }
    return null;
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
  }
}
