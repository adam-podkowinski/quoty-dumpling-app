import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';

enum Rarities {
  common,
  rare,
  epic,
  legendary,
}

class Quote {
  final quote;
  final author;
  final id;
  var isUnlocked;
  var isFavorite;
  DateTime? unlockingTime;
  final Rarities rarity;

  Quote({
    required this.quote,
    required this.author,
    required this.rarity,
    required this.id,
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
      //isUnlocked: true,
      //unlockingTime: DateTime.now(),
    );
  }

  void unlockedFromDatabase(Map<String, dynamic> map) {
    isUnlocked = true;
    isFavorite = map['isFavorite'] == 1 ? true : false;
    unlockingTime = DateTime.parse(map['unlockingTime']);
  }

  Color rarityColor(BuildContext context) {
    switch (rarity) {
      case Rarities.common:
        return ThemeColors.primary;
      case Rarities.rare:
        return ThemeColors.rare;
      case Rarities.epic:
        return ThemeColors.epic;
      default:
        return ThemeColors.legendary;
    }
  }

  String rarityText() {
    switch (rarity) {
      case Rarities.common:
        return 'Common';
      case Rarities.rare:
        return 'Rare';
      case Rarities.epic:
        return 'Epic';
      default:
        return 'Legendary';
    }
  }

  static Rarities getRarityByText(String? rarityText) {
    switch (rarityText) {
      case 'common':
        return Rarities.common;
      case 'rare':
        return Rarities.rare;
      case 'epic':
        return Rarities.epic;
      default:
        return Rarities.legendary;
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
        'unlockingTime': unlockingTime!.toIso8601String(),
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
