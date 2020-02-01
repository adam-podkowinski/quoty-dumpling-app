import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

enum SortEnum {
  RARITY,
  RARITY_DESCENDING,
  NEWEST,
  OLDEST,
}

class CollectionSettings extends ChangeNotifier {
  SortEnum _selectedOption = SortEnum.RARITY_DESCENDING;
  SortEnum get selectedOption {
    return _selectedOption;
  }

  bool _showOnlyFavorite = false;
  bool get showOnlyFavorite {
    return _showOnlyFavorite;
  }

  Map<String, dynamic> _previousOptions = {};

  void initOptions() {
    _previousOptions['selectedOption'] = _selectedOption;
    _previousOptions['showOnlyFavorite'] = _showOnlyFavorite;
  }

  void cancelOptions() {
    _selectedOption = _previousOptions['selectedOption'];
    _showOnlyFavorite = _previousOptions['showOnlyFavorite'];
  }

  void saveOptions(BuildContext context) {
    Provider.of<Quotes>(context, listen: false)
        .updateSortOptions(_selectedOption, _showOnlyFavorite);
    Provider.of<Quotes>(context, listen: false).sortCollection();
  }

  void changeShowOnlyFavorite(bool val) {
    _showOnlyFavorite = val;
    notifyListeners();
  }

  void changeSelectedVal(int n) {
    _selectedOption = SortEnum.values[n];
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
