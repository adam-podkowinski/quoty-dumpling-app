import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart'
    show SortEnum;
import 'package:shared_preferences/shared_preferences.dart';

class Quotes extends ChangeNotifier {
  final List<Quote> _quotes = [];
  List<Quote> _visibleQuotes = [];
  final List<Quote> _unlockedQuotes = [];
  final List<Quote> _quotesToUnlock = [];
  final List<Quote> _newQuotes = [];
  // This list is sorted first and after playing half of the animation visibleQuotes are set to this. This affects the animation
  List<Quote> _visibleQuotesCopy = [];

  final List<int> _collectionTilesToAnimate = [];
  SortEnum? _sortOption;
  bool? _favoritesOnTop = false;
  var _animateCollectionTiles = false;
  var _previousQuotes = [];
  String _searchValue = '';
  static const Duration animationDuration = Duration(milliseconds: 300);

  bool get animateCollectionTiles {
    return _animateCollectionTiles;
  }

  bool? get favoritesOnTop {
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

  List<Quote> get newQuotes {
    return [..._newQuotes];
  }

  List<int> get collectionTilesToAnimate {
    return [..._collectionTilesToAnimate];
  }

  Future<void> fetchQuotes() async {
    print('fetching quotes');
    List<dynamic>? contents;
    var contentsB = await rootBundle.load('assets/quotes/quotes.json');

    //because json file is huge
    contents = await jsonDecode(
      utf8.decode(contentsB.buffer.asUint8List(), allowMalformed: true),
    );
    _quotes.clear();

    _quotes.addAll(
      contents!.map((e) => Quote.fromMap(e)),
    );

    final _unlockedQuotesFromDB =
        await DBProvider.db.getAllElements('UnlockedQuotes');

    //debug
    // _unlockedQuotes.addAll(
    //   _quotes.where((e) => e.isUnlocked),
    // );

    _unlockedQuotesFromDB.forEach((e) {
      _unlockedQuotes.add(
        _quotes.firstWhere((q) => q.id == e['id'])..unlockedFromDatabase(e),
      );
    });

    _quotesToUnlock.addAll(
      _quotes.where((e) => e.isUnlocked != true),
      // debug
      // _quotes
    );

    final prefs = await SharedPreferences.getInstance();
    _favoritesOnTop = prefs.getBool('favoritesOnTop') ?? false;
    _sortOption = SortEnum.values[prefs.getInt('sortOption') ?? 0];
  }

  Quote unlockRandomQuote() {
    if (_quotesToUnlock.isNotEmpty) {
      var index = Random().nextInt(_quotesToUnlock.length - 1);
      _quotesToUnlock[index].unlockThisQuote();
      var unlockedQuote = _quotesToUnlock[index];
      _newQuotes.insert(0, _quotesToUnlock[index]);
      _quotesToUnlock.remove(_quotesToUnlock[index]);
      return unlockedQuote;
    } else {
      return Quote(
        author: 'No quotes loaded',
        quote: 'No quotes loaded',
        rarity: Rarity.legendary,
        id: 'No quotes loaded',
      );
    }
  }

  Quote unlockRandomQuoteFromRarity(Rarity rarity) {
    if (_quotesToUnlock.isNotEmpty) {
      var q = _quotesToUnlock
          .where((element) => rarity.isHigherOrEqualInHierarchy(element.rarity))
          .toList();

      var randomQuoteIndex = Random().nextInt(q.length - 1);

      var index = _quotesToUnlock
          .indexWhere((element) => element.id == q[randomQuoteIndex].id);

      _quotesToUnlock[index].unlockThisQuote();
      var unlockedQuote = _quotesToUnlock[index];
      _newQuotes.insert(0, _quotesToUnlock[index]);
      _quotesToUnlock.remove(_quotesToUnlock[index]);
      return unlockedQuote;
    } else {
      return Quote(
        author: 'No quotes loaded',
        quote: 'No quotes loaded',
        rarity: Rarity.legendary,
        id: 'No quotes loaded',
      );
    }
  }

  void addToUnlockedFromNew() {
    if (!(_newQuotes.isNotEmpty)) return;
    _unlockedQuotes.addAll(_newQuotes);
    _visibleQuotes = [...unlockedQuotes];
    _newQuotes.clear();
    sortCollection(false);
    searchCollection(_searchValue);
  }

  void initCollectionTilesToAnimate() {
    _collectionTilesToAnimate.clear();
    _visibleQuotesCopy.asMap().forEach((index, quote) {
      if (!(quote == _previousQuotes[index])) {
        _collectionTilesToAnimate.add(index);
      }
    });
    _animateCollectionTiles = true;
    notifyListeners();
    Future.delayed(animationDuration, () {
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
    if (_favoritesOnTop!) {
      var favoritedQuotes =
          _visibleQuotesCopy.where((e) => e.isFavorite).toList();
      _visibleQuotesCopy =
          _visibleQuotesCopy.where((e) => !e.isFavorite).toList();
      _visibleQuotesCopy.insertAll(0, favoritedQuotes);
    }
  }

  void _sortByNewest() {
    _visibleQuotesCopy.sort(
      (a, b) => b.unlockingTime!.compareTo(a.unlockingTime!),
    );
  }

  void _sortByOldest() {
    _visibleQuotesCopy.sort(
      (a, b) => a.unlockingTime!.compareTo(b.unlockingTime!),
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
        for (var i = 0; i < a.author.length; i++) {
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
    WidgetsBinding.instance!.addPostFrameCallback((_) => notifyListeners());
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
      WidgetsBinding.instance!.addPostFrameCallback((_) => notifyListeners());
    }
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
    _searchValue = value;
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
