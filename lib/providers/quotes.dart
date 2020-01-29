import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart'
    show SortEnum;

class Quotes extends ChangeNotifier {
  List<Quote> _quotes = [];
  List<Quote> _unlockedQuotes = [];
  List<Quote> _quotesToUnlock = [];
  SortEnum _sortOption = SortEnum.RARITY_DESCENDING;

  List<Quote> get quotes {
    return [..._quotes];
  }

  List<Quote> get unlockedQuotes {
    return [..._unlockedQuotes];
  }

  List<Quote> get quotesToUnlock {
    return [..._quotesToUnlock];
  }

  Future<void> fetchQuotes() async {
    List<dynamic> contents;
    ByteData contentsB = await rootBundle.load('assets/quotes/quotes.json');
    contents = jsonDecode(
      utf8.decode(contentsB.buffer.asUint8List(), allowMalformed: true),
    );
    _quotes.clear();
    contents.forEach(
      (e) {
        _quotes.add(
          Quote(
            quote: e['quoteText'],
            author: e['quoteAuthor'],
            isFavorite: false,
            rarity: Quote.getRarityByText(e['rarity']),
            isUnlocked: false,
            // isUnlocked: true,
            // unlockingTime: DateTime.now(),
            // rarity: Rarities.EPIC
          ),
        );
      },
    );
    _unlockedQuotes.addAll(
      _quotes.where((e) => e.isUnlocked == true),
    );
    _quotesToUnlock.addAll(
      _quotes.where((e) => e.isUnlocked != true),
    );
  }

  void updateSortOptions(SortEnum option) {
    _sortOption = option;
  }

  void sortCollection() {
    switch (_sortOption) {
      case SortEnum.NEWEST:
        _unlockedQuotes.sort(
          (a, b) => b.unlockingTime.compareTo(a.unlockingTime),
        );
        break;
      case SortEnum.OLDEST:
        _unlockedQuotes.sort(
          (a, b) => a.unlockingTime.compareTo(b.unlockingTime),
        );
        break;
      case SortEnum.RARITY:
        _unlockedQuotes.sort(
          (a, b) => a.unlockingTime.compareTo(b.unlockingTime),
        );
        break;
      default:
        _unlockedQuotes.sort(
          (a, b) => b.unlockingTime.compareTo(a.unlockingTime),
        );
        break;
    }
  }

  Quote unlockRandomQuote() {
    if (_quotes.length > 0) {
      int index = Random().nextInt(_quotesToUnlock.length - 1);
      _quotesToUnlock[index].unlockThisQuote();
      Quote unlockedQuote = _quotesToUnlock[index];
      _unlockedQuotes.add(_quotesToUnlock[index]);
      _quotesToUnlock.remove(_quotesToUnlock[index]);
      return unlockedQuote;
    } else
      return Quote(
        author: 'No quotes loaded',
        quote: 'No quotes loaded',
      );
  }
}
