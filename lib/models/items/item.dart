import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quoty_dumpling_app/helpers/item_functions.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/models/items/money_item.dart';
import 'package:quoty_dumpling_app/models/items/powerup_item.dart';
import 'package:quoty_dumpling_app/models/items/upgrade_item.dart';

enum IconType {
  BILLS,
  CLICKS,
  OPENING,
  LEVEL,
  ADS,
}

enum UseCase {
  BILLS_ON_CLICK,
  CASH_ON_OPENING,
  CLICK_MULTIPLIER,
  LEVEL_XP_MULTIPLIER,
  REMOVE_ADS,
}

abstract class LabeledItem extends ShopItem {
  bool hasLabel = true;
  LabeledItem.fromMap(map) : super.fromMap(map);

  String getLabel();
}

abstract class ShopItem {
  String? name;
  String? description;
  int? defaultPriceBills;
  int? defaultPriceDiamonds;
  int? priceUSD;
  String? id;
  IconType? iconType;
  late Function onBuyFunction;
  UseCase? useCase;

  int? actualPriceBills;
  int? actualPriceDiamonds;

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
    useCase = useCaseFromString(map['useCase']);
    iconType = iconTypeFromString(map['useCase']);
    actualPriceBills = defaultPriceBills;
    actualPriceDiamonds = defaultPriceDiamonds;
    onBuyFunction = itemFunctions['onBuyFunction$id'] ??
        (context) => print('Function for this item is not yet prepared');
  }

  void buyItem(context) => onBuyFunction(context);

  void fetchFromDB(Map<String, dynamic> map) {}

  IconData itemTypeIcon() {
    switch (iconType) {
      case IconType.BILLS:
        return CustomIcons.dollar;
      case IconType.OPENING:
        return CustomIcons.opening;
      case IconType.LEVEL:
        return CustomIcons.levelup;
      case IconType.ADS:
        return Icons.favorite;
      default:
        {
          return CustomIcons.click;
        }
    }
  }

  static UseCase useCaseFromString(String? uType) {
    switch (uType) {
      case 'clickMultiplier':
        return UseCase.CLICK_MULTIPLIER;
      case 'billsOnClick':
        return UseCase.BILLS_ON_CLICK;
      case 'xpMultiplier':
        return UseCase.LEVEL_XP_MULTIPLIER;
      case 'removeAds':
        return UseCase.REMOVE_ADS;
      default:
        return UseCase.CASH_ON_OPENING;
    }
  }

  static IconType iconTypeFromString(String? iType) {
    switch (iType) {
      case 'clickMultiplier':
        return IconType.CLICKS;
      case 'billsOnClick':
        return IconType.BILLS;
      case 'xpMultiplier':
        return IconType.LEVEL;
      case 'removeAds':
        return IconType.ADS;
      default:
        return IconType.OPENING;
    }
  }
}
