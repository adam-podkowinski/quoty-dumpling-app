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
    @required this.quote,
    @required this.author,
    @required this.rarity,
    this.isUnlocked = false,
    this.isFavorite = false,
    this.unlockingTime,
  });

  static Quote fromMap(Map<String, dynamic> map) {
    return Quote(
      quote: map['quoteText'],
      author: map['quoteAuthor'] == '' ? 'Unknown' : map['quoteAuthor'],
      rarity: Quote.getRarityByText(map['rarity']),
      //debug
      // isUnlocked: true,
      // unlockingTime: DateTime.now(),
    );
  }

  Color rarityColor(BuildContext context) {
    switch (rarity) {
      case Rarities.COMMON:
        return Theme.of(context).primaryColor;
        break;
      case Rarities.RARE:
        return Styles.rareColor;
        break;
      case Rarities.EPIC:
        return Styles.epicColor;
        break;
      default:
        return Styles.legendaryColor;
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

  void changeFavorite() {
    isFavorite = !isFavorite;
  }
}
