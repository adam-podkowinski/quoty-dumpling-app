import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart'
    show SortEnum;
import 'package:shared_preferences/shared_preferences.dart';

class Quotes extends ChangeNotifier {
  List<Quote> _quotes = [];
  List<Quote> _visibleQuotes = [];
  List<Quote> _unlockedQuotes = [];
  List<Quote> _quotesToUnlock = [];

  // This list is sorted first and after playing half of the animation visibleQuotes are set to this. This affects to the animation
  List<Quote> _visibleQuotesCopy = [];
  List<int> _collectionTilesToAnimate = [];
  SortEnum _sortOption;
  var _favoritesOnTop = false;
  var _animateCollectionTiles = false;
  var _previousQuotes = [];
  var _areQuotesLoading = false;
  static const Duration animationTime = const Duration(milliseconds: 300);

  bool get animateCollectionTiles {
    return _animateCollectionTiles;
  }

  bool get areQuotesLoading {
    return _areQuotesLoading;
  }

  bool get favoritesOnTop {
    return _favoritesOnTop;
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
    contents = await jsonDecode(
      utf8.decode(contentsB.buffer.asUint8List(), allowMalformed: true),
    );
    _quotes.clear();

    _quotes.addAll(
      contents.map((e) => Quote.fromMap(e)),
    );

    //debug
    // DBProvider.db.deleteAllElements('UnlockedQuotes');

    final _unlockedQuotesFromDB =
        await DBProvider.db.getAllElements('UnlockedQuotes');

    _unlockedQuotesFromDB.forEach((e) {
      _unlockedQuotes.add(
        _quotes.firstWhere((q) => q.id == e['id'])..unlockedFromDatabase(e),
      );
    });

    _quotesToUnlock.addAll(
      _quotes.where((e) => e.isUnlocked != true),
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _favoritesOnTop = prefs.getBool('favoritesOnTop') ?? false;
    _sortOption = SortEnum.values[prefs.getInt('sortOption') ?? 1];
  }

  Quote unlockRandomQuote() {
    if (_quotesToUnlock.length > 0) {
      int index = Random().nextInt(_quotesToUnlock.length - 1);
      _quotesToUnlock[index].unlockThisQuote();
      Quote unlockedQuote = _quotesToUnlock[index];
      _unlockedQuotes.add(_quotesToUnlock[index]);
      _visibleQuotes = [..._unlockedQuotes];
      _quotesToUnlock.remove(_quotesToUnlock[index]);
      return unlockedQuote;
    } else
      return Quote(
        author: 'No quotes loaded',
        quote: 'No quotes loaded',
        rarity: Rarities.LEGENDARY,
        id: 'No quotes loaded',
      );
  }

  void initCollectionTilesToAnimate() {
    _collectionTilesToAnimate.clear();
    _visibleQuotesCopy.asMap().forEach((index, quote) {
      if (!(quote == _previousQuotes[index])) {
        _collectionTilesToAnimate.add(index);
      }
    });
    _animateCollectionTiles = true;
    _areQuotesLoading = false;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 300), () {
      _animateCollectionTiles = false;
      _visibleQuotes = [..._visibleQuotesCopy];
      notifyListeners();
    });
  }

//Sorting options
  void updateSortOptions(Map<String, dynamic> options) {
    _sortOption = options['sortOption'];
    _favoritesOnTop = options['favoritesOnTop'];
  }

  void _sortByFavorite() {
    if (_favoritesOnTop) {
      List<Quote> favoritedQuotes =
          _visibleQuotesCopy.where((e) => e.isFavorite).toList();
      _visibleQuotesCopy =
          _visibleQuotesCopy.where((e) => !e.isFavorite).toList();
      _visibleQuotesCopy.insertAll(0, favoritedQuotes);
    }
  }

  void _sortByNewest() {
    _visibleQuotesCopy.sort(
      (a, b) => b.unlockingTime.compareTo(a.unlockingTime),
    );
  }

  void _sortByOldest() {
    _visibleQuotesCopy.sort(
      (a, b) => a.unlockingTime.compareTo(b.unlockingTime),
    );
  }

  void _sortByRarity() {
    _sortByNewest();
    _visibleQuotesCopy.sort(
      (a, b) => a.rarity.index.compareTo(b.rarity.index),
    );
  }

  void _sortByRarityDescending() {
    _sortByNewest();
    _visibleQuotesCopy.sort(
      (a, b) => b.rarity.index.compareTo(a.rarity.index),
    );
  }

  void _sortByAuthor() {
    _sortByRarity();
    _visibleQuotesCopy.sort(
      (a, b) {
        for (int i = 0; i < a.author.length; i++) {
          try {
            if (a.author[i].compareTo(b.author[i]) != 0) {
              return a.author[i].compareTo(b.author[i]);
            }
          } on RangeError catch (_) {
            return a.author[i - 1].compareTo(b.author[i - 1]);
          }
        }
        return a.author.compareTo(b.author);
      },
    );
  }
  //

  void refreshVisibleQuotes() {
    _visibleQuotes = _unlockedQuotes;
  }

  void sortCollection(bool shouldAnimate) {
    _areQuotesLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    _previousQuotes = [..._visibleQuotes];
    _visibleQuotesCopy = [..._visibleQuotes];
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
      case SortEnum.AUTHOR:
        _sortByAuthor();
        break;
      default:
        _sortByRarityDescending();
    }
    _sortByFavorite();
    if (shouldAnimate) {
      initCollectionTilesToAnimate();
    } else {
      _visibleQuotes = _visibleQuotesCopy;
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
    _areQuotesLoading = false;
  }

//searching
  String _simplifyString(String val) {
    return val
        .toLowerCase()
        .trim()
        .replaceAll(' ', '')
        .replaceAll(',', '')
        .replaceAll('.', '')
        .replaceAll('\'', '')
        .replaceAll(':', '')
        .replaceAll('"', '')
        .replaceAll('-', '');
  }

  void searchCollection(String value) {
    if (value != '') {
      _visibleQuotes = _unlockedQuotes
          .where(
            (e) =>
                //first
                _simplifyString(e.quote).contains(
                  _simplifyString(value),
                ) ||
                //second
                _simplifyString(e.author).contains(
                  _simplifyString(value),
                ) ||
                //third
                _simplifyString(e.rarityText()).contains(
                  _simplifyString(value),
                ),
          )
          .toList();
    } else {
      refreshVisibleQuotes();
    }
    sortCollection(false);
  }
}
