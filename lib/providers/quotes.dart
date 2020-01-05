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
    contents.forEach(
      (e) {
        _items.add(
          Quote(
            quote: e['quoteText'],
            author: e['quoteAuthor'],
            isFavorite: false,
            isUnlocked: false,
            rarity: Quote.getRarityByText(e['rarity']),
          ),
        );
      },
    );
  }

  Quote unlockRandomQuote() {
    if (_items.length > 0) {
      int index = Random().nextInt(_items.length - 1);
      _items[index].unlockThisQuote();
      return _items[index];
    } else
      return Quote(
        author: 'No quotes loaded',
        quote: 'No quotes loaded',
      );
  }
}
