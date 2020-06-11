import 'package:flutter/widgets.dart';
import 'package:quoty_dumpling_app/helpers/item_functions.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/models/items/moneyItem.dart';
import 'package:quoty_dumpling_app/models/items/powerupItem.dart';
import 'package:quoty_dumpling_app/models/items/upgradeItem.dart';

enum IconType {
  BILLS,
  CLICKS,
}

abstract class LabeledItem extends ShopItem {
  bool hasLabel = true;
  LabeledItem.fromMap(map) : super.fromMap(map);

  String getLabel();
}

abstract class ShopItem {
  String name;
  String description;
  int defaultPriceBills;
  int defaultPriceDiamonds;
  int priceUSD;
  String id;
  IconType iconType;
  Function onBuyFunction;

  int actualPriceBills;
  int actualPriceDiamonds;

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
    onBuyFunction = ItemFunctions.itemFunctions['onBuyFunction$id'] ??
        (context) => print('Function for this item is not yet prepared');
  }

  void buyItem(context) => onBuyFunction(context);

  void fetchFromDB(Map<String, dynamic> map) {}

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
}
