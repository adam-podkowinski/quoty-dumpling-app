import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show BuildContext, Curves, ScrollController;
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionSettings extends ChangeNotifier {
  Map<String, dynamic> _selectedOptions = {};
  Map<String, dynamic> _savedOptions = {};
  ScrollController? _scrollController;

  bool _showScrollFab = false;
  final List<List<String>> _titlesWithSubtitlesOfOptions = [
    [
      'By Rarity Descending',
      'Sort from the rarest to the commonest',
    ],
    [
      'By Rarity',
      'Sort from the commonest to the rarest',
    ],
    [
      'By Author',
      'Sort alphabetically',
    ],
    [
      'From Newest',
      'Show the newest quotes at the top',
    ],
    [
      'From Oldest',
      'Show the oldest quotes at the top',
    ],
  ];

  ScrollController? get scrollController {
    if (_scrollController != null) {
      return _scrollController;
    } else {
      initScrollControlller();
    }
    return _scrollController;
  }

  Map<String, dynamic> get selectedOptions => _selectedOptions;

  bool get showScrollFab => _showScrollFab;

  List<List<String>> get titlesWithSubtitlesOfOptions =>
      _titlesWithSubtitlesOfOptions;

  void changeSelectedFavoritesOnTop(bool? val) {
    _selectedOptions['favoritesOnTop'] = val;
    notifyListeners();
  }

  void changeSelectedSortOption(int n) {
    _selectedOptions['sortOption'] = SortEnum.values[n];
    notifyListeners();
  }

  void disposeScrollController() => _scrollController!.dispose();

  Future<void> initOptions() async {
    final prefs = await SharedPreferences.getInstance();
    _savedOptions['sortOption'] =
        SortEnum.values[prefs.getInt('sortOption') ?? 0];
    _savedOptions['favoritesOnTop'] = prefs.getBool('favoritesOnTop') ?? false;
  }

  void initOptionsDialog() {
    _selectedOptions = {
      'sortOption': _savedOptions['sortOption'],
      'favoritesOnTop': _savedOptions['favoritesOnTop'],
    };
  }

  void initScrollControlller() {
    _showScrollFab = false;
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.offset > 300 && !_showScrollFab) {
          _showScrollFab = true;
          notifyListeners();
        } else if (_scrollController!.offset < 300 && _showScrollFab) {
          _showScrollFab = false;
          notifyListeners();
        }
      });
  }

  void refreshScrollFab() {
    if (_showScrollFab) {
      _showScrollFab = false;
      notifyListeners();
    }
  }

  Future<void> saveOptions(BuildContext context) async {
    _savedOptions = _selectedOptions;

    Provider.of<Quotes>(context, listen: false).updateSortOptions(
      _savedOptions,
    );
    Provider.of<Quotes>(context, listen: false).sortCollection(true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'sortOption',
      _savedOptions['sortOption'].index,
    );
    await prefs.setBool(
      'favoritesOnTop',
      _savedOptions['favoritesOnTop'] ?? false,
    );
  }

  void scrollUp() => _scrollController!.animateTo(0,
      duration: Duration(milliseconds: 400), curve: Curves.easeIn);
}

enum SortEnum {
  RARITY_DESCENDING,
  RARITY,
  AUTHOR,
  NEWEST,
  OLDEST,
}
