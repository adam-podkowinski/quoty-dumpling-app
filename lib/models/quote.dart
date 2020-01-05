import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';

enum Rarities {
  COMMON,
  RARE,
  EPIC,
  LEGENDARY,
}

class Quote {
  final quote;
  final author;
  var isUnlocked;
  var isFavorite;
  DateTime unlockingTime;
  final Rarities rarity;

  Quote({
    this.quote,
    this.author,
    this.isUnlocked,
    this.isFavorite,
    this.rarity,
    this.unlockingTime,
  });

  Color rarityColor(BuildContext context) {
    switch (rarity) {
      case Rarities.COMMON:
        return Theme.of(context).primaryColor;
        break;
      case Rarities.RARE:
        return rareColor;
        break;
      case Rarities.EPIC:
        return epicColor;
        break;
      default:
        return legendaryColor;
    }
  }

  String rarityText() {
    switch (rarity) {
      case Rarities.COMMON:
        return 'Common';
        break;
      case Rarities.RARE:
        return 'Rare';
        break;
      case Rarities.EPIC:
        return 'Epic';
        break;
      default:
        return 'Legendary';
    }
  }

  static Rarities getRarityByText(String rarityText) {
    switch (rarityText) {
      case 'common':
        return Rarities.COMMON;
        break;
      case 'rare':
        return Rarities.RARE;
        break;
      case 'epic':
        return Rarities.EPIC;
        break;
      default:
        return Rarities.LEGENDARY;
    }
  }

  void unlockThisQuote() {
    isUnlocked = true;
    unlockingTime = DateTime.now();
  }
}
