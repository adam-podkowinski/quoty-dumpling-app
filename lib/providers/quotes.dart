import 'dart:async';
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
  List<Quote> _visibleQuotes = [];
  List<Quote> _unlockedQuotes = [];
  List<Quote> _quotesToUnlock = [];
  List<int> _collectionTilesToAnimate = [];
  SortEnum _sortOption = SortEnum.RARITY_DESCENDING;
  var _favoritesOnTop = false;
  var _animateCollectionTiles = false;
  var _previousQuotes = [];
  var _areQuotesLoading = false;

  bool get animateCollectionTiles {
    return _animateCollectionTiles;
  }

  bool get areQuotesLoading {
    return _areQuotesLoading;
  }

  List<Quote> get quotes {
    return [..._quotes];
  }

  List<Quote> get unlockedQuotes {
    return [..._unlockedQuotes];
  }

  List<Quote> get visibleQuotes {
    return [..._visibleQuotes];
  }

  List<Quote> get quotesToUnlock {
    return [..._quotesToUnlock];
  }

  List<int> get collectionTilesToAnimate {
    return [..._collectionTilesToAnimate];
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
    _visibleQuotes.addAll(_unlockedQuotes);
  }

  void updateSortOptions(SortEnum option, bool showOnlyFavorite) {
    _sortOption = option;
    _favoritesOnTop = showOnlyFavorite;
  }

  void sortByFavorite(bool isInitSort) {
    if (_favoritesOnTop) {
      _visibleQuotes.sort((a, b) {
        int aNum = 0;
        int bNum = 0;
        if (a.isFavorite) aNum = 1;
        if (b.isFavorite) bNum = 1;
        return bNum.compareTo(aNum);
      });
    }
    if (!isInitSort) {
      initCollectionTilesToAnimate();
    }
  }

  void initCollectionTilesToAnimate() {
    _collectionTilesToAnimate.clear();
    _visibleQuotes.asMap().forEach((index, quote) {
      if (!(quote == _previousQuotes[index])) {
        _collectionTilesToAnimate.add(index);
      }
    });
    _animateCollectionTiles = true;
    _areQuotesLoading = false;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 200), () {
      _animateCollectionTiles = false;
      notifyListeners();
    });
  }

  void _sortByNewest() {
    _visibleQuotes.sort(
      (a, b) => b.unlockingTime.compareTo(a.unlockingTime),
    );
  }

  void _sortByOldest() {
    _visibleQuotes.sort(
      (a, b) => a.unlockingTime.compareTo(b.unlockingTime),
    );
  }

  void _sortByRarity() {
    _sortByNewest();
    _visibleQuotes.sort(
      (a, b) => a.rarity.index.compareTo(b.rarity.index),
    );
  }

  void _sortByRarityDescending() {
    _sortByNewest();
    _visibleQuotes.sort(
      (a, b) => b.rarity.index.compareTo(a.rarity.index),
    );
  }

  void sortCollection(bool isInitSort) {
    _areQuotesLoading = true;
    notifyListeners();
    _previousQuotes = [..._visibleQuotes];
    switch (_sortOption) {
      case SortEnum.NEWEST:
        _sortByNewest();
        break;
      case SortEnum.OLDEST:
        _sortByOldest();
        break;
      case SortEnum.RARITY:
        _sortByRarity();
        break;
      default:
        _sortByRarityDescending();
    }
    if (isInitSort) {
      _areQuotesLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    } else {
      sortByFavorite(isInitSort);
    }
  }

  Quote unlockRandomQuote() {
    if (_quotes.length > 0) {
      int index = Random().nextInt(_quotesToUnlock.length - 1);
      _quotesToUnlock[index].unlockThisQuote();
      Quote unlockedQuote = _quotesToUnlock[index];
      _unlockedQuotes.add(_quotesToUnlock[index]);
      _visibleQuotes.add(_quotesToUnlock[index]);
      _quotesToUnlock.remove(_quotesToUnlock[index]);
      return unlockedQuote;
    } else
      return Quote(
        author: 'No quotes loaded',
        quote: 'No quotes loaded',
      );
  }
}
