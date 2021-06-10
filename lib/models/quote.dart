import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';

enum Rarity {
  common,
  rare,
  epic,
  legendary,
}

extension RarityFunctions on Rarity {
  bool isHigherOrEqualInHierarchy(Rarity r) {
    switch (this) {

      //ITS COMMON
      case Rarity.common:
        return true;

      //ITS RARE
      case Rarity.rare:
        switch (r) {
          case Rarity.common:
            return false;
          default:
            return true;
        }

      //ITS EPIC
      case Rarity.epic:
        switch (r) {
          case Rarity.common:
            return false;
          case Rarity.rare:
            return false;
          default:
            return true;
        }

      //ITS LEGENDARY
      default:
        return r == Rarity.legendary;
    }
  }
}

class Quote {
  final quote;
  final author;
  final id;
  var isUnlocked;
  var isFavorite;
  DateTime? unlockingTime;
  final Rarity rarity;

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
      case Rarity.common:
        return ThemeColors.primary;
      case Rarity.rare:
        return ThemeColors.rare;
      case Rarity.epic:
        return ThemeColors.epic;
      default:
        return ThemeColors.legendary;
    }
  }

  String rarityText() {
    switch (rarity) {
      case Rarity.common:
        return 'Common';
      case Rarity.rare:
        return 'Rare';
      case Rarity.epic:
        return 'Epic';
      default:
        return 'Legendary';
    }
  }

  static Rarity getRarityByText(String? rarityText) {
    switch (rarityText) {
      case 'common':
        return Rarity.common;
      case 'rare':
        return Rarity.rare;
      case 'epic':
        return Rarity.epic;
      default:
        return Rarity.legendary;
    }
  }

  static String getTextByRarity(Rarity rarityEnum) {
    switch (rarityEnum) {
      case Rarity.common:
        return 'Common';
      case Rarity.rare:
        return 'Rare';
      case Rarity.epic:
        return 'Epic';
      default:
        return 'Legendary';
    }
  }

  Future<void> unlockThisQuote(BuildContext context) async {
    isUnlocked = true;
    unlockingTime = DateTime.now();

    await DBProvider.insert(
      'UnlockedQuotes',
      {
        'id': id,
        'isFavorite': 0,
        'unlockingTime': unlockingTime!.toIso8601String(),
      },
    );
  }

  void changeFavorite(BuildContext context) {
    isFavorite = !isFavorite;

    Provider.of<DBProvider>(context, listen: false).updateElementById(
      'UnlockedQuotes',
      id,
      {'isFavorite': isFavorite ? 1 : 0},
    );
  }
}
