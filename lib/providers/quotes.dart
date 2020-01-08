import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/models/quote.dart';

class Quotes extends ChangeNotifier {
  List<Quote> _quotes = [];
  List<Quote> _unlockedQuotes = [];
  List<Quote> _quotesToUnlock = [];
  var _raritySortingMoreImportant = true;
  var _sortFromNewest = true;
  var _sortByRarityDescending = false;

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
            isUnlocked: false,
            rarity: Quote.getRarityByText(e['rarity']),
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

  void _sortCollectionByRarity() {
    _sortByRarityDescending
        ? _unlockedQuotes.sort(
            (a, b) => b.rarity.index.compareTo(a.rarity.index),
          )
        : _unlockedQuotes.sort(
            (a, b) => a.rarity.index.compareTo(b.rarity.index),
          );
  }

  void _sortCollectionByUnlockingDate() {
    _sortFromNewest
        ? _unlockedQuotes.sort(
            (a, b) => b.unlockingTime.compareTo(a.unlockingTime),
          )
        : _unlockedQuotes.sort(
            (a, b) => a.unlockingTime.compareTo(b.unlockingTime),
          );
  }

  void sortCollection() {
    if (_raritySortingMoreImportant) {
      _sortCollectionByUnlockingDate();
      _sortCollectionByRarity();
    } else {
      _sortCollectionByRarity();
      _sortCollectionByUnlockingDate();
    }
    // notifyListeners();
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
