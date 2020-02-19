import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/data/DBProvider.dart';
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
  final id;
  var isUnlocked;
  var isFavorite;
  DateTime unlockingTime;
  final Rarities rarity;

  Quote({
    @required this.quote,
    @required this.author,
    @required this.rarity,
    @required this.id,
    this.isUnlocked = false,
    this.isFavorite = false,
    this.unlockingTime,
  });

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      quote: map['quoteText'],
      author: map['quoteAuthor'] == '' ? 'Unknown' : map['quoteAuthor'],
      rarity: Quote.getRarityByText(map['rarity']),
      id: map['id'],
      //debug
      isUnlocked: true,
      unlockingTime: DateTime.now(),
    );
  }

  void unlockedFromDatabase(Map<String, dynamic> map) {
    isUnlocked = true;
    isFavorite = map['isFavorite'] == 1 ? true : false;
    unlockingTime = DateTime.parse(map['unlockingTime']);
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

  Future<void> unlockThisQuote() async {
    isUnlocked = true;
    unlockingTime = DateTime.now();

    await DBProvider.db.insert(
      'UnlockedQuotes',
      {
        'id': id,
        'isFavorite': 0,
        'unlockingTime': unlockingTime.toIso8601String(),
      },
    );
  }

  void changeFavorite() {
    isFavorite = !isFavorite;

    DBProvider.db.updateElementById(
      'UnlockedQuotes',
      id,
      {'isFavorite': isFavorite ? 1 : 0},
    );
  }
}
