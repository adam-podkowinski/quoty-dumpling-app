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
  var isInCollection;
  var isFavorite;
  DateTime unlockingTime;
  final Rarities rarity;

  Quote({
    this.quote,
    this.author,
    this.isInCollection,
    this.isFavorite,
    this.rarity,
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
}
