import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/models/quote.dart';

class Quotes extends ChangeNotifier {
  List<Quote> _items = [];

  List<Quote> get items {
    return [..._items];
  }

  Future<void> fetchQuotes() async {
    List<dynamic> contents;
    ByteData contentsB = await rootBundle.load('assets/quotes/quotes.json');
    contents = jsonDecode(
      utf8.decode(contentsB.buffer.asUint8List(), allowMalformed: true),
    );
    _items.clear();
    contents.asMap().forEach(
      (index, e) {
        _items.add(
          Quote(
            quote: e['quoteText'],
            author: e['quoteAuthor'],
            isFavorite: false,
            isInCollection: false,
            rarity: index <= (contents.length - 1) * .25
                ? Rarities.COMMON
                : index <= (contents.length - 1) * .50
                    ? Rarities.RARE
                    : index <= (contents.length - 1) * .75
                        ? Rarities.EPIC
                        : Rarities.LEGENDARY,
          ),
        );
      },
    );
    notifyListeners();
  }

  Quote unlockRandomQuote() {
    if (_items.length > 0) {
      int index = Random().nextInt(_items.length - 1);
      _items[index].isInCollection = true;
      return _items[index];
    } else
      return Quote(
        author: '',
        quote: '',
      );
  }

  String rarityText(Rarities rarity) {
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
}
