import 'package:flutter/foundation.dart';

enum SortEnum {
  RARITY,
  RARITY_DESCENDING,
  NEWEST,
  OLDEST,
}

class CollectionSettings extends ChangeNotifier {
  int _selectedValue = 0;
  int get selectedValue {
    return _selectedValue;
  }

  bool _showOnlyFavorite = false;
  bool get showOnlyFavorite {
    return _showOnlyFavorite;
  }

  void changeShowOnlyFavorite(bool val) {
    _showOnlyFavorite = val;
    notifyListeners();
  }

  void changeSelectedVal(int n) {
    _selectedValue = n;
    notifyListeners();
  }

  List<List<String>> _titlesWithSubtitlesOfOptions = [
    [
      'By Rarity',
      'Sort from the rarest to the commonest',
    ],
    [
      'By Rarity Descending',
      'Sort from the commonest to the rarest',
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
  List<List<String>> get titlesWithSubtitlesOfOptions {
    return _titlesWithSubtitlesOfOptions;
  }
}
